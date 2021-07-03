library ieee;
use ieee.numeric_std.std_match;
use ieee.std_logic_1164.all;

package utils is
    function to_bstring(b : bit) return string;
    function to_bstring(bv : bit_vector) return string;
    function to_bstring(sl : std_logic) return string;
    function to_bstring(slv : std_logic_vector) return string;

    procedure assertEquals(slv1: std_logic_vector; slv2: std_logic_vector);
    procedure assertEquals(bv1: bit_vector; bv2: bit_vector);
    procedure assertEquals(bv: bit_vector; slv: std_logic_vector);
    procedure assertEquals(slv: std_logic_vector; bv: bit_vector);
end utils;

package body utils is

    function to_bstring(b : bit) return string is
        variable b_str_v : string(1 to 3);  -- bit image with quotes around
    begin
        b_str_v := bit'image(b);
        return "" & b_str_v(2);  -- "" & character to get string
    end function;

    function to_bstring(bv : bit_vector) return string is
        alias    bv_norm : bit_vector(1 to bv'length) is bv;
        variable b_str_v : string(1 to 1);  -- String of bit
        variable res_v   : string(1 to bv'length);
    begin
        for idx in bv_norm'range loop
            b_str_v := to_bstring(bv_norm(idx));
            res_v(idx) := b_str_v(1);
        end loop;
        return res_v;
    end function;

    function to_bstring(sl : std_logic) return string is
        variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
      begin
        sl_str_v := std_logic'image(sl);
        return "" & sl_str_v(2);  -- "" & character to get string
      end function;
      
    function to_bstring(slv : std_logic_vector) return string is
        alias    slv_norm : std_logic_vector(1 to slv'length) is slv;
        variable sl_str_v : string(1 to 1);  -- String of std_logic
        variable res_v    : string(1 to slv'length);
    begin
        for idx in slv_norm'range loop
            sl_str_v := to_bstring(slv_norm(idx));
            res_v(idx) := sl_str_v(1);
        end loop;
        return res_v;
    end function;

    procedure assertEquals(slv1: std_logic_vector; slv2: std_logic_vector) is
    begin
        assert std_match(slv1, slv2)
            report "Test failed. "&
                "Expected "& to_bstring(slv1) &" "&
                "but got" & to_bstring(slv2)
            severity warning;
    end procedure;

    procedure assertEquals(bv1: bit_vector; bv2: bit_vector) is
    begin
        assertEquals(to_stdlogicvector(bv1), to_stdlogicvector(bv2));
    end procedure;

    procedure assertEquals(bv: bit_vector; slv: std_logic_vector) is
    begin
        assertEquals(to_stdlogicvector(bv), slv);
    end procedure;

    procedure assertEquals(slv: std_logic_vector; bv: bit_vector) is
    begin
        assertEquals(slv, to_stdlogicvector(bv));
    end procedure;

end utils;
