use work.utils.all;

entity alu1bit_tb is
end entity;

architecture arch of alu1bit_tb is

    component alu1bit is
        port(
            a, b, less, cin: in bit;
            result, cout, set, overflow: out bit;
            ainvert, binvert: in bit;
            operation: in bit_vector(1 downto 0)
        );
    end component;

    type test_case_type is record
        aluCtrl: bit_vector(3 downto 0);
        a, b,
        result: bit;
    end record;
    type test_case_array is array(1 to 16) of test_case_type;
    -- Assuming sum and co work from fa1bit test
    constant TEST_CASES: test_case_array := (
        -- AND
        ("0000", '0','0', '0'),
        ("0000", '0','1', '0'),
        ("0000", '1','0', '0'),
        ("0000", '1','1', '1'),
        -- OR
        ("0001", '0','0', '0'),
        ("0001", '0','1', '1'),
        ("0001", '1','0', '1'),
        ("0001", '1','1', '1'),
        -- Pass B
        ("0111", '0','0', '0'),
        ("0111", '0','1', '1'),
        ("0111", '1','0', '0'),
        ("0111", '1','1', '1'),
        -- NOR
        ("1100", '0','0', '1'),
        ("1100", '0','1', '0'),
        ("1100", '1','0', '0'),
        ("1100", '1','1', '0')
    );

    signal aluCtrl: bit_vector(3 downto 0);
    signal a, b, result: bit;

begin

    dut: alu1bit port map(
        a, b, '0', '0',
        result, open, open, open,
        aluCtrl(3), aluCtrl(2), aluCtrl(1 downto 0)
    );

    tb: process
    begin
        report "BOT";
        for i in TEST_CASES'range loop
            aluCtrl <= TEST_CASES(i).aluCtrl;
            a <= TEST_CASES(i).a;
            b <= TEST_CASES(i).b;
            wait for 1 ps;
            assert_equals(""&TEST_CASES(i).result, ""&result, i);
        end loop;
        report "EOT";
        wait;
    end process;

end architecture arch;
