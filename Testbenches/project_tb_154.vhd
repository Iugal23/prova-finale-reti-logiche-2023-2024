-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 469;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,169,0,0,0,69,0,83,0,217,0,117,0,78,0,77,0,67,0,0,0,237,0,231,0,16,0,7,0,9,0,0,0,37,0,0,0,134,0,91,0,94,0,108,0,216,0,0,0,107,0,202,0,96,0,0,0,97,0,79,0,160,0,168,0,69,0,138,0,0,0,226,0,33,0,76,0,27,0,48,0,14,0,183,0,247,0,30,0,0,0,250,0,197,0,78,0,59,0,88,0,13,0,249,0,142,0,207,0,215,0,179,0,100,0,68,0,154,0,73,0,69,0,230,0,66,0,212,0,0,0,92,0,11,0,122,0,0,0,199,0,247,0,0,0,67,0,0,0,0,0,216,0,135,0,20,0,254,0,156,0,37,0,0,0,233,0,202,0,120,0,45,0,27,0,140,0,47,0,23,0,0,0,0,0,146,0,194,0,123,0,174,0,131,0,0,0,120,0,0,0,66,0,84,0,209,0,0,0,249,0,78,0,159,0,165,0,239,0,93,0,0,0,231,0,67,0,127,0,81,0,100,0,255,0,212,0,16,0,136,0,195,0,193,0,158,0,198,0,235,0,167,0,252,0,0,0,145,0,184,0,254,0,167,0,24,0,125,0,0,0,43,0,148,0,63,0,11,0,223,0,246,0,19,0,0,0,73,0,238,0,0,0,9,0,255,0,135,0,160,0,161,0,224,0,100,0,110,0,82,0,147,0,50,0,194,0,225,0,197,0,148,0,0,0,18,0,126,0,210,0,228,0,114,0,68,0,191,0,89,0,127,0,121,0,247,0,195,0,201,0,141,0,252,0,216,0,114,0,0,0,206,0,251,0,167,0,238,0,210,0,0,0,0,0,215,0,0,0,9,0,156,0,200,0,172,0,252,0,35,0,104,0,0,0,0,0,227,0,0,0,0,0,140,0,176,0,110,0,211,0,236,0,0,0,107,0,171,0,0,0,33,0,183,0,166,0,219,0,40,0,119,0,167,0,65,0,11,0,120,0,0,0,203,0,154,0,38,0,45,0,0,0,141,0,119,0,113,0,222,0,99,0,148,0,4,0,0,0,0,0,93,0,90,0,105,0,233,0,0,0,144,0,99,0,34,0,126,0,211,0,175,0,0,0,147,0,163,0,117,0,236,0,150,0,166,0,153,0,27,0,125,0,118,0,84,0,0,0,102,0,0,0,88,0,0,0,209,0,185,0,113,0,0,0,70,0,0,0,40,0,190,0,6,0,47,0,214,0,60,0,47,0,160,0,74,0,49,0,21,0,78,0,0,0,82,0,0,0,0,0,253,0,193,0,111,0,45,0,8,0,0,0,126,0,209,0,150,0,0,0,0,0,242,0,26,0,140,0,136,0,215,0,219,0,192,0,137,0,113,0,106,0,214,0,48,0,0,0,180,0,114,0,4,0,103,0,0,0,139,0,0,0,34,0,0,0,207,0,166,0,179,0,31,0,130,0,193,0,32,0,0,0,73,0,173,0,148,0,18,0,119,0,0,0,100,0,246,0,42,0,45,0,55,0,82,0,92,0,236,0,0,0,221,0,139,0,150,0,194,0,175,0,101,0,0,0,151,0,126,0,0,0,245,0,244,0,0,0,186,0,241,0,241,0,72,0,42,0,0,0,4,0,0,0,109,0,117,0,40,0,144,0,150,0,233,0,205,0,208,0,80,0,0,0,54,0,204,0,63,0,237,0,145,0,243,0,186,0,105,0,0,0,112,0,195,0,80,0,207,0,0,0,227,0,64,0,130,0,0,0,188,0,104,0,194,0,0,0,0,0,0,0,61,0,242,0,146,0,91,0,243,0,0,0,0,0,201,0,0,0,243,0,219,0,76,0,43,0,247,0,56,0,243,0,241,0,110,0,133,0,247,0,0,0,182,0,0,0,242,0,1,0,0,0,190,0,147,0,72,0,81,0,0,0,228,0,77,0,0,0,0,0,137,0,0,0,110,0,138,0,220,0,197,0,0,0,118,0,51,0,224,0,105,0,0,0,17,0,122,0,0,0,54,0,39,0,156,0,218,0,17,0,0,0,123,0,124,0,0,0,0,0,185,0,20,0,220,0,0,0,188,0,194,0,168,0,189,0,39,0,227,0,236,0,47,0);
signal scenario_full  : scenario_type := (0,0,169,31,169,30,69,31,83,31,217,31,117,31,78,31,77,31,67,31,67,30,237,31,231,31,16,31,7,31,9,31,9,30,37,31,37,30,134,31,91,31,94,31,108,31,216,31,216,30,107,31,202,31,96,31,96,30,97,31,79,31,160,31,168,31,69,31,138,31,138,30,226,31,33,31,76,31,27,31,48,31,14,31,183,31,247,31,30,31,30,30,250,31,197,31,78,31,59,31,88,31,13,31,249,31,142,31,207,31,215,31,179,31,100,31,68,31,154,31,73,31,69,31,230,31,66,31,212,31,212,30,92,31,11,31,122,31,122,30,199,31,247,31,247,30,67,31,67,30,67,29,216,31,135,31,20,31,254,31,156,31,37,31,37,30,233,31,202,31,120,31,45,31,27,31,140,31,47,31,23,31,23,30,23,29,146,31,194,31,123,31,174,31,131,31,131,30,120,31,120,30,66,31,84,31,209,31,209,30,249,31,78,31,159,31,165,31,239,31,93,31,93,30,231,31,67,31,127,31,81,31,100,31,255,31,212,31,16,31,136,31,195,31,193,31,158,31,198,31,235,31,167,31,252,31,252,30,145,31,184,31,254,31,167,31,24,31,125,31,125,30,43,31,148,31,63,31,11,31,223,31,246,31,19,31,19,30,73,31,238,31,238,30,9,31,255,31,135,31,160,31,161,31,224,31,100,31,110,31,82,31,147,31,50,31,194,31,225,31,197,31,148,31,148,30,18,31,126,31,210,31,228,31,114,31,68,31,191,31,89,31,127,31,121,31,247,31,195,31,201,31,141,31,252,31,216,31,114,31,114,30,206,31,251,31,167,31,238,31,210,31,210,30,210,29,215,31,215,30,9,31,156,31,200,31,172,31,252,31,35,31,104,31,104,30,104,29,227,31,227,30,227,29,140,31,176,31,110,31,211,31,236,31,236,30,107,31,171,31,171,30,33,31,183,31,166,31,219,31,40,31,119,31,167,31,65,31,11,31,120,31,120,30,203,31,154,31,38,31,45,31,45,30,141,31,119,31,113,31,222,31,99,31,148,31,4,31,4,30,4,29,93,31,90,31,105,31,233,31,233,30,144,31,99,31,34,31,126,31,211,31,175,31,175,30,147,31,163,31,117,31,236,31,150,31,166,31,153,31,27,31,125,31,118,31,84,31,84,30,102,31,102,30,88,31,88,30,209,31,185,31,113,31,113,30,70,31,70,30,40,31,190,31,6,31,47,31,214,31,60,31,47,31,160,31,74,31,49,31,21,31,78,31,78,30,82,31,82,30,82,29,253,31,193,31,111,31,45,31,8,31,8,30,126,31,209,31,150,31,150,30,150,29,242,31,26,31,140,31,136,31,215,31,219,31,192,31,137,31,113,31,106,31,214,31,48,31,48,30,180,31,114,31,4,31,103,31,103,30,139,31,139,30,34,31,34,30,207,31,166,31,179,31,31,31,130,31,193,31,32,31,32,30,73,31,173,31,148,31,18,31,119,31,119,30,100,31,246,31,42,31,45,31,55,31,82,31,92,31,236,31,236,30,221,31,139,31,150,31,194,31,175,31,101,31,101,30,151,31,126,31,126,30,245,31,244,31,244,30,186,31,241,31,241,31,72,31,42,31,42,30,4,31,4,30,109,31,117,31,40,31,144,31,150,31,233,31,205,31,208,31,80,31,80,30,54,31,204,31,63,31,237,31,145,31,243,31,186,31,105,31,105,30,112,31,195,31,80,31,207,31,207,30,227,31,64,31,130,31,130,30,188,31,104,31,194,31,194,30,194,29,194,28,61,31,242,31,146,31,91,31,243,31,243,30,243,29,201,31,201,30,243,31,219,31,76,31,43,31,247,31,56,31,243,31,241,31,110,31,133,31,247,31,247,30,182,31,182,30,242,31,1,31,1,30,190,31,147,31,72,31,81,31,81,30,228,31,77,31,77,30,77,29,137,31,137,30,110,31,138,31,220,31,197,31,197,30,118,31,51,31,224,31,105,31,105,30,17,31,122,31,122,30,54,31,39,31,156,31,218,31,17,31,17,30,123,31,124,31,124,30,124,29,185,31,20,31,220,31,220,30,188,31,194,31,168,31,189,31,39,31,227,31,236,31,47,31);

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
