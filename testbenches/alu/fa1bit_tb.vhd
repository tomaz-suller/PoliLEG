use work.utils.all;

entity fa1bit_tb is
end entity;

architecture arch of fa1bit_tb is

    component fa1bit is
        port(
            a, b, cin: in bit;
            result, cout: out bit
        );
    end component;

    type test_case_type is record
        stimulus: bit_vector(2 downto 0);
        response: bit_vector(1 downto 0);
    end record;
    type test_case_array is array(7 downto 0) of test_case_type;
    constant TEST_CASES: test_case_array := (
        ("000", "00"),
        ("001", "01"),
        ("010", "01"),
        ("011", "10"),
        ("100", "01"),
        ("101", "10"),
        ("110", "10"),
        ("111", "11")
    );

    signal x: bit_vector(2 downto 0);
    signal y: bit_vector(1 downto 0);

begin

    dut: fa1bit
        port map(x(0),x(1),x(2), y(0),y(1));

    tb: process
    begin
        report "BOT";
        for i in TEST_CASES'range loop
            x <= TEST_CASES(i).stimulus;
            wait for 1 ps;
            assert_equals(TEST_CASES(i).response, y, i);
        end loop;
        report "EOT";
        wait;
    end process;

end architecture arch;
