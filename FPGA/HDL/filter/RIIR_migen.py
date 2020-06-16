from migen import *
from migen.fhdl.verilog import convert as convert2verilog
import numpy as np



class RIIR(Module):
    """Robert style first order IIR filter with (real) poles at 1-2**(-b) with b
    being the number of bits. Higher b move the Pole closer and closer to +1,
    leading to a very narrow lowpass. The b_0 coeff is 2**(-b) for a DC gain of one,
    therefore the filter can be implemented with only bitshifting, subtracting and adding.
    The filter can be dynamically reconfigured with the b parameter. Each b the filter
    cutoff freq halfes. The Output is always registered.

    Parameter:
        w_dat: input and output width
        w_z: substractor width - for accuracy, the core will implement the b_0
            gain after the feedback for b+w_dat<=w_z and split the gain to before
            and after for higher b. Example:
            b=24; w_dat=32; w_z=48 ==> 16bit gain bitshift after feedback,
            8bit gain bitshift before feedback
        w_b: width of b parameter
        b_min: smallest possible value of b, gets added to the b input
        pipe: if true the core will take an input every second clockcycle,
            perform the substraction and addition pipelined and produce an output
            every second clockcycle. Als input and z shift regs are applied if the
            tick option is set, too. Not a pipelined filter!
        tick: if true the core will compute an iteration starting every tick posedge.
            If pipelined the output will be updated on the third next clk.
            Fastest possible tickrate is 1/3 clk!!!!
    """

    def __init__(self, w_dat=32, w_z=48, w_b=4, b_min=0, pipe=False, tick=False):

        assert w_z>=w_dat , "internal reg needs to be wider than output"

        # IO signals
        # =============================================================
        self.inp = Signal((w_dat,True))             # input signal
        self.outp = Signal((w_dat,True))            # output signal
        self.b = Signal(w_b)                        # b parameter
        if tick:
            self.tick=Signal()                      # tick input

        # Generation Variables
        # =============================================================
        w_b_reg=int(np.ceil(np.log2(b_min+2**w_b)))        # width of internal b
        postshiftmax=w_z-w_dat
        if(postshiftmax<=0):  # thats probably not smart..
            postshiftmax=1
        preshiftmax=(w_dat+2**w_b_reg)-w_z
        if(preshiftmax<=0):
            preshiftmax=1;
        w_preshift = int(np.ceil(np.log2(preshiftmax)))
        if (w_preshift <= 0):
            w_preshift = 1;
        w_postshift = int(np.ceil(np.log2(postshiftmax)))
        if (w_postshift <= 0):
            w_postshift = 1;

        # Internal signals
        # =============================================================
        self.z = Signal((w_z,True))                 # feedback delay reg
        self.preshift=Signal(w_preshift)
        self.postshift=Signal(w_postshift)
        self.b_reg=Signal(w_b_reg)  # b reg
        if pipe:
            self.p_step=Signal()                    # internal signal for pipeline step
            self.p_reg=Signal((w_z,True))           # pipeline reg
            self.z_shift_reg = Signal((w_z,True))   # additional reg for shifted z
            self.inp_shift_reg = Signal((w_dat,True))# reg for pre-shifted input
        if tick:
            self.tick_l=Signal()                    # last tick reg

        # Logic
        # =============================================================
        self.comb += If(self.b_reg>=postshiftmax-1,
              self.postshift.eq(postshiftmax-1),
              self.preshift.eq(self.b_reg - (postshiftmax-1))
              ).Else(
            self.preshift.eq(0),
            self.postshift.eq(self.b_reg)
        )

        self.sync+=self.b_reg.eq(self.b+b_min)

        if not tick:
            if not pipe:
                self.sync+=self.z.eq((self.inp >> self.preshift)+(self.z-(self.z>>self.b_reg)))

            else:   # pipelined
                self.sync+=[
                    self.p_step.eq(~self.p_step),
                    If(self.p_step,
                        self.p_reg.eq(self.z-(self.z>>self.b_reg))           # first subtraction
                    ).Else(
                        self.z.eq((self.inp >> self.preshift)+self.p_reg)   # then addition
                    )
                ]
        else:
            if not pipe:
                self.sync += If(self.tick&~self.tick_l,           # if posedge tick
                    self.z.eq((self.inp >> self.preshift) + (self.z - (self.z >> self.b_reg))))

            else:  # extra pipelined with last z getting pre-shifted
                self.sync += [self.z_shift_reg.eq(self.z >> self.b_reg),
                    self.inp_shift_reg.eq(self.inp >> self.preshift),
                    If(self.tick&~self.tick_l&~self.p_step,           # if posedge tick
                        self.p_step.eq(1),
                        self.p_reg.eq(self.z - self.z_shift_reg)  # first subtraction
                        ),
                    If(self.p_step,
                        self.z.eq((self.inp_shift_reg) + self.p_reg),  # then addition
                        self.p_step.eq(0)
                    )
                ]



        self.sync+=self.outp.eq(self.z >> (self.postshift))


        # unf too much Logic:
        # surpress output spikes during parameter change
        # self.sync += If(self.b_reg!=self.b+b_min,
        #                 If(self.b>=postshiftmax-1,
        #                    self.z.eq(self.outp<<postshiftmax-1))        # grr
        #                 .Else(
        #                     self.z.eq(self.outp << self.b)
        #                 ))



# Testbench with tick
# =============================================================
def RIIR_tb(dut):
    for i in range(2**14):
        yield
        if i==3:
            yield dut.inp.eq(1<<11)

        if (i%2)==0:
            yield dut.tick.eq(~dut.tick)
        if i==10:
            yield dut.b.eq(0x8)
        if i==1000:
            yield dut.b.eq(0x0)
        if i==1050:
            yield dut.inp.eq(0xfff)
        #if i==1200:
        #    yield dut.b.eq(0x13)
        # if i==1300:
        #     yield dut.inp.eq(0xfffff)


if __name__ == "__main__":
    sim=False
    conv2v=True
    iir = RIIR(b_min=10,pipe=True,tick=True)
    #iir=RIIR()

    if sim:
        run_simulation(iir, RIIR_tb(iir), vcd_name="file.vcd")
    iir = RIIR(b_min=10,pipe=True,tick=True)
    if conv2v:
        o = convert2verilog(iir, name="RIIR", ios={iir.inp, iir.outp, iir.b, iir.tick})
        with open('RIIR.v', 'w') as file:
            file.write(o.main_source)
        print(o.main_source)

