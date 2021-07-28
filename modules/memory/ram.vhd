library ieee;
use ieee.math_real.all;
use ieee.numeric_bit.all;
use std.textio.all;

entity ram is
  generic(
    mem_width_in_bits: natural := 64;
    word_size: natural := 64;
    mem_word_size: natural := 8;
    init_file: string := "../software/gcd/ram.dat"
  );
  port(
    ck, wr : in  bit;
    addr   : in  bit_vector(mem_width_in_bits-1 downto 0);
    data_i : in  bit_vector(word_size-1 downto 0);
    data_o : out bit_vector(word_size-1 downto 0)
  );
end ram;

architecture arch of ram is
  constant ADDR_BITS_TO_SKIP: natural := natural(ceil(log2(real(word_size)/real(mem_word_size))));
  constant ALIGNED_MEM_WIDTH: natural := mem_width_in_bits - ADDR_BITS_TO_SKIP;

  type mem_type is array(0 to 2**ALIGNED_MEM_WIDTH-1)
    of bit_vector(word_size-1 downto 0);

  impure function fread(fname: in string) return mem_type is
    file f: text open read_mode is fname;
    variable l: line;
    variable tmp_bv: bit_vector(word_size-1 downto 0);
    variable tmp_mem: mem_type;
    variable i: integer := 0;
  begin

    while not endfile(f) and i <= 2**ALIGNED_MEM_WIDTH-1 loop
      readline(f, l);
      read(l, tmp_bv);
      tmp_mem(i) := tmp_bv;
      i := i + 1;
    end loop;

    while i <= 2**ALIGNED_MEM_WIDTH-1 loop
      tmp_mem(i) := bit_vector(to_unsigned(0, word_size));
      i := i + 1;
    end loop;

    return tmp_mem;
  end;

  signal mem: mem_type := fread(init_file);
  signal aligned_addr: bit_vector(ALIGNED_MEM_WIDTH-1 downto 0);

begin

  aligned_addr <= addr(mem_width_in_bits-1 downto ADDR_BITS_TO_SKIP);
  data_o <= mem(to_integer(unsigned(aligned_addr)));

  process(ck, wr)
  begin
    if rising_edge(ck) then
      if wr = '1' then
        mem(to_integer(unsigned(aligned_addr))) <= data_i;
      end if;
    end if;
  end process;

end arch;
