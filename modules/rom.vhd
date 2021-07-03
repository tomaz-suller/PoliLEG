library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity rom is
  generic(
    mem_width_in_bits: natural := 64;
    word_size: natural := 64;
    init_file: string := "../software/rom.dat"
  );
  port(
    addr   : in  bit_vector(mem_width_in_bits-1 downto 0);
    data_o : out bit_vector(word_size-1 downto 0)
  );
end rom;

architecture arch of rom is

  constant ALIGNED_MEM_WIDTH: natural := mem_width_in_bits-2;

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
  aligned_addr <= addr(mem_width_in_bits-1 downto 2);
  data_o <= mem(to_integer(unsigned(aligned_addr)));
end arch;