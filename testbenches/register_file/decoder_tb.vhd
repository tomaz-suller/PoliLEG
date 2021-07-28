entity decoder_tb is
end entity;

architecture arch of decoder_tb is

    component decoder is
        generic(
            inputSizeInBits: natural := 5
        );
        port(
            in_bv: in bit_vector(inputSizeInBits-1 downto 0);
            out_bv: out bit_vector((2**inputSizeInBits)-1 downto 0)
        );
    end component;

    constant INPUT_SIZE: natural := 3;
    type test_case_type is record
        stimulus: bit_vector(INPUT_SIZE-1 downto 0);
        response: bit_vector((2**INPUT_SIZE)-1 downto 0);
    end record;
    type test_case_array is array(0 to (2**INPUT_SIZE)-1) of test_case_type;
    constant TEST_CASES: test_case_array := (
        ("000", "00000001"),
        ("001", "00000010"),
        ("010", "00000100"),
        ("011", "00001000"),
        ("100", "00010000"),
        ("101", "00100000"),
        ("110", "01000000"),
        ("111", "10000000")
    );

    signal x: bit_vector(INPUT_SIZE-1 downto 0);
    signal y: bit_vector((2**INPUT_SIZE)-1 downto 0);

begin

    dut: decoder
        generic map(INPUT_SIZE)
        port map(x, y);

    tb: process
        variable expected_response: bit_vector((2**INPUT_SIZE)-1 downto 0);
    begin
        report "BOT";
        for i in TEST_CASES'range loop
            x <= TEST_CASES(i).stimulus;
            expected_response := TEST_CASES(i).response;
            wait for 1 ps;
            assert y = expected_response
                report "Test "&integer'image(i)&" failed."
                severity warning;
        end loop;
        report "EOT";
        wait;
    end process;

end architecture arch;
