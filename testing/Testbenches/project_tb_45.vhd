-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_45 is
end project_tb_45;

architecture project_tb_arch_45 of project_tb_45 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 529;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (192,0,0,0,192,0,208,0,153,0,244,0,164,0,226,0,86,0,123,0,21,0,25,0,165,0,6,0,0,0,7,0,82,0,0,0,80,0,247,0,13,0,20,0,0,0,0,0,211,0,157,0,0,0,177,0,0,0,72,0,77,0,102,0,236,0,0,0,99,0,66,0,164,0,0,0,0,0,186,0,0,0,166,0,205,0,192,0,233,0,99,0,232,0,0,0,130,0,89,0,127,0,189,0,183,0,165,0,215,0,119,0,170,0,0,0,154,0,123,0,15,0,237,0,217,0,0,0,192,0,107,0,8,0,0,0,0,0,22,0,146,0,165,0,137,0,137,0,36,0,66,0,211,0,41,0,0,0,0,0,37,0,0,0,219,0,221,0,0,0,7,0,214,0,0,0,121,0,31,0,0,0,0,0,172,0,48,0,0,0,47,0,207,0,202,0,199,0,210,0,74,0,111,0,73,0,0,0,57,0,37,0,236,0,134,0,0,0,103,0,45,0,178,0,237,0,144,0,178,0,127,0,101,0,0,0,168,0,171,0,204,0,56,0,96,0,171,0,0,0,97,0,93,0,174,0,60,0,186,0,23,0,5,0,135,0,181,0,205,0,151,0,243,0,249,0,101,0,128,0,19,0,64,0,130,0,120,0,10,0,83,0,233,0,254,0,149,0,101,0,0,0,26,0,195,0,151,0,203,0,0,0,237,0,53,0,220,0,171,0,147,0,0,0,0,0,18,0,53,0,114,0,63,0,222,0,135,0,0,0,0,0,0,0,0,0,74,0,235,0,59,0,127,0,108,0,4,0,143,0,208,0,40,0,145,0,233,0,94,0,52,0,168,0,160,0,0,0,185,0,0,0,177,0,245,0,184,0,150,0,73,0,147,0,44,0,59,0,250,0,110,0,159,0,204,0,107,0,126,0,68,0,93,0,0,0,81,0,45,0,200,0,0,0,0,0,128,0,228,0,4,0,232,0,210,0,0,0,124,0,217,0,0,0,122,0,87,0,190,0,205,0,190,0,0,0,0,0,36,0,185,0,249,0,129,0,108,0,136,0,125,0,54,0,155,0,0,0,143,0,0,0,248,0,165,0,0,0,0,0,30,0,220,0,204,0,71,0,47,0,53,0,171,0,151,0,17,0,107,0,61,0,203,0,83,0,218,0,106,0,146,0,79,0,71,0,192,0,0,0,18,0,192,0,136,0,0,0,0,0,0,0,159,0,112,0,28,0,104,0,20,0,70,0,0,0,0,0,167,0,0,0,49,0,20,0,25,0,6,0,155,0,0,0,193,0,0,0,167,0,47,0,140,0,74,0,220,0,0,0,253,0,218,0,72,0,222,0,0,0,0,0,0,0,197,0,221,0,0,0,0,0,0,0,199,0,70,0,17,0,68,0,70,0,111,0,0,0,125,0,110,0,195,0,154,0,0,0,0,0,102,0,0,0,65,0,213,0,97,0,219,0,0,0,166,0,191,0,46,0,221,0,66,0,200,0,194,0,230,0,14,0,76,0,151,0,67,0,245,0,0,0,91,0,0,0,0,0,0,0,184,0,221,0,252,0,0,0,0,0,49,0,232,0,111,0,161,0,12,0,41,0,0,0,148,0,156,0,0,0,47,0,8,0,44,0,174,0,0,0,5,0,0,0,155,0,0,0,0,0,0,0,126,0,6,0,0,0,155,0,36,0,127,0,0,0,34,0,73,0,200,0,2,0,119,0,204,0,221,0,198,0,90,0,178,0,188,0,146,0,141,0,192,0,153,0,48,0,83,0,201,0,34,0,41,0,132,0,193,0,248,0,190,0,77,0,0,0,21,0,86,0,66,0,0,0,218,0,185,0,140,0,148,0,218,0,51,0,113,0,57,0,19,0,116,0,0,0,17,0,180,0,215,0,123,0,216,0,254,0,154,0,151,0,95,0,4,0,187,0,31,0,250,0,87,0,0,0,52,0,203,0,123,0,158,0,0,0,177,0,162,0,118,0,94,0,193,0,18,0,72,0,109,0,220,0,0,0,7,0,95,0,107,0,215,0,0,0,183,0,189,0,54,0,31,0,103,0,132,0,0,0,30,0,198,0,211,0,0,0,0,0,111,0,179,0,56,0,187,0,185,0,0,0,165,0,189,0,0,0,21,0,132,0,215,0,144,0,29,0,185,0,0,0,76,0,205,0,21,0,205,0,185,0,111,0,0,0,141,0,153,0,0,0,129,0,154,0,84,0,70,0,146,0,112,0,100,0,67,0,198,0,235,0,0,0,0,0,165,0,13,0,218,0,215,0,13,0,198,0,18,0,223,0,229,0,165,0,21,0,152,0,39,0,36,0,130,0,0,0,152,0,252,0,0,0,0,0,205,0,146,0,131,0,90,0,0,0);
signal scenario_full  : scenario_type := (192,31,192,30,192,31,208,31,153,31,244,31,164,31,226,31,86,31,123,31,21,31,25,31,165,31,6,31,6,30,7,31,82,31,82,30,80,31,247,31,13,31,20,31,20,30,20,29,211,31,157,31,157,30,177,31,177,30,72,31,77,31,102,31,236,31,236,30,99,31,66,31,164,31,164,30,164,29,186,31,186,30,166,31,205,31,192,31,233,31,99,31,232,31,232,30,130,31,89,31,127,31,189,31,183,31,165,31,215,31,119,31,170,31,170,30,154,31,123,31,15,31,237,31,217,31,217,30,192,31,107,31,8,31,8,30,8,29,22,31,146,31,165,31,137,31,137,31,36,31,66,31,211,31,41,31,41,30,41,29,37,31,37,30,219,31,221,31,221,30,7,31,214,31,214,30,121,31,31,31,31,30,31,29,172,31,48,31,48,30,47,31,207,31,202,31,199,31,210,31,74,31,111,31,73,31,73,30,57,31,37,31,236,31,134,31,134,30,103,31,45,31,178,31,237,31,144,31,178,31,127,31,101,31,101,30,168,31,171,31,204,31,56,31,96,31,171,31,171,30,97,31,93,31,174,31,60,31,186,31,23,31,5,31,135,31,181,31,205,31,151,31,243,31,249,31,101,31,128,31,19,31,64,31,130,31,120,31,10,31,83,31,233,31,254,31,149,31,101,31,101,30,26,31,195,31,151,31,203,31,203,30,237,31,53,31,220,31,171,31,147,31,147,30,147,29,18,31,53,31,114,31,63,31,222,31,135,31,135,30,135,29,135,28,135,27,74,31,235,31,59,31,127,31,108,31,4,31,143,31,208,31,40,31,145,31,233,31,94,31,52,31,168,31,160,31,160,30,185,31,185,30,177,31,245,31,184,31,150,31,73,31,147,31,44,31,59,31,250,31,110,31,159,31,204,31,107,31,126,31,68,31,93,31,93,30,81,31,45,31,200,31,200,30,200,29,128,31,228,31,4,31,232,31,210,31,210,30,124,31,217,31,217,30,122,31,87,31,190,31,205,31,190,31,190,30,190,29,36,31,185,31,249,31,129,31,108,31,136,31,125,31,54,31,155,31,155,30,143,31,143,30,248,31,165,31,165,30,165,29,30,31,220,31,204,31,71,31,47,31,53,31,171,31,151,31,17,31,107,31,61,31,203,31,83,31,218,31,106,31,146,31,79,31,71,31,192,31,192,30,18,31,192,31,136,31,136,30,136,29,136,28,159,31,112,31,28,31,104,31,20,31,70,31,70,30,70,29,167,31,167,30,49,31,20,31,25,31,6,31,155,31,155,30,193,31,193,30,167,31,47,31,140,31,74,31,220,31,220,30,253,31,218,31,72,31,222,31,222,30,222,29,222,28,197,31,221,31,221,30,221,29,221,28,199,31,70,31,17,31,68,31,70,31,111,31,111,30,125,31,110,31,195,31,154,31,154,30,154,29,102,31,102,30,65,31,213,31,97,31,219,31,219,30,166,31,191,31,46,31,221,31,66,31,200,31,194,31,230,31,14,31,76,31,151,31,67,31,245,31,245,30,91,31,91,30,91,29,91,28,184,31,221,31,252,31,252,30,252,29,49,31,232,31,111,31,161,31,12,31,41,31,41,30,148,31,156,31,156,30,47,31,8,31,44,31,174,31,174,30,5,31,5,30,155,31,155,30,155,29,155,28,126,31,6,31,6,30,155,31,36,31,127,31,127,30,34,31,73,31,200,31,2,31,119,31,204,31,221,31,198,31,90,31,178,31,188,31,146,31,141,31,192,31,153,31,48,31,83,31,201,31,34,31,41,31,132,31,193,31,248,31,190,31,77,31,77,30,21,31,86,31,66,31,66,30,218,31,185,31,140,31,148,31,218,31,51,31,113,31,57,31,19,31,116,31,116,30,17,31,180,31,215,31,123,31,216,31,254,31,154,31,151,31,95,31,4,31,187,31,31,31,250,31,87,31,87,30,52,31,203,31,123,31,158,31,158,30,177,31,162,31,118,31,94,31,193,31,18,31,72,31,109,31,220,31,220,30,7,31,95,31,107,31,215,31,215,30,183,31,189,31,54,31,31,31,103,31,132,31,132,30,30,31,198,31,211,31,211,30,211,29,111,31,179,31,56,31,187,31,185,31,185,30,165,31,189,31,189,30,21,31,132,31,215,31,144,31,29,31,185,31,185,30,76,31,205,31,21,31,205,31,185,31,111,31,111,30,141,31,153,31,153,30,129,31,154,31,84,31,70,31,146,31,112,31,100,31,67,31,198,31,235,31,235,30,235,29,165,31,13,31,218,31,215,31,13,31,198,31,18,31,223,31,229,31,165,31,21,31,152,31,39,31,36,31,130,31,130,30,152,31,252,31,252,30,252,29,205,31,146,31,131,31,90,31,90,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
