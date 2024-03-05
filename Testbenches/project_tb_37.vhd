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

constant SCENARIO_LENGTH : integer := 342;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (209,0,239,0,0,0,50,0,221,0,184,0,153,0,204,0,68,0,0,0,81,0,199,0,82,0,91,0,0,0,122,0,0,0,171,0,212,0,227,0,78,0,0,0,29,0,144,0,0,0,51,0,223,0,157,0,0,0,211,0,42,0,178,0,59,0,130,0,133,0,22,0,6,0,91,0,227,0,164,0,91,0,224,0,23,0,182,0,0,0,97,0,0,0,136,0,39,0,201,0,129,0,236,0,108,0,82,0,247,0,218,0,176,0,66,0,55,0,24,0,0,0,91,0,129,0,98,0,0,0,218,0,34,0,181,0,0,0,0,0,80,0,115,0,58,0,176,0,0,0,0,0,133,0,251,0,153,0,126,0,71,0,73,0,46,0,181,0,0,0,128,0,206,0,17,0,0,0,0,0,0,0,70,0,0,0,0,0,225,0,248,0,58,0,76,0,31,0,50,0,85,0,0,0,189,0,84,0,107,0,51,0,35,0,37,0,41,0,139,0,189,0,219,0,174,0,107,0,17,0,0,0,0,0,244,0,35,0,20,0,0,0,0,0,0,0,0,0,0,0,27,0,97,0,156,0,20,0,105,0,0,0,0,0,0,0,28,0,214,0,119,0,219,0,0,0,0,0,0,0,116,0,0,0,3,0,162,0,229,0,110,0,163,0,0,0,106,0,225,0,0,0,196,0,39,0,0,0,53,0,134,0,67,0,117,0,146,0,94,0,243,0,165,0,142,0,38,0,120,0,56,0,0,0,114,0,0,0,137,0,148,0,255,0,0,0,132,0,144,0,243,0,142,0,255,0,0,0,12,0,69,0,47,0,0,0,0,0,72,0,136,0,34,0,78,0,224,0,0,0,163,0,168,0,213,0,19,0,24,0,208,0,96,0,156,0,0,0,0,0,176,0,15,0,0,0,0,0,0,0,243,0,159,0,71,0,0,0,73,0,0,0,68,0,183,0,80,0,245,0,0,0,141,0,50,0,129,0,0,0,243,0,0,0,247,0,19,0,38,0,219,0,78,0,40,0,247,0,12,0,113,0,171,0,96,0,80,0,73,0,136,0,211,0,131,0,17,0,139,0,235,0,176,0,165,0,234,0,124,0,0,0,134,0,0,0,184,0,86,0,182,0,74,0,0,0,195,0,128,0,145,0,0,0,32,0,190,0,127,0,14,0,0,0,0,0,16,0,154,0,125,0,226,0,246,0,95,0,198,0,187,0,0,0,0,0,0,0,231,0,0,0,45,0,0,0,112,0,89,0,95,0,170,0,249,0,32,0,0,0,245,0,71,0,149,0,7,0,42,0,55,0,0,0,208,0,0,0,0,0,0,0,52,0,105,0,23,0,58,0,7,0,215,0,5,0,142,0,185,0,193,0,39,0,0,0,114,0,0,0,202,0,226,0,0,0,71,0,0,0,0,0,76,0,177,0,242,0,197,0,163,0,157,0,207,0,0,0,108,0,231,0,198,0,130,0,0,0,61,0,51,0,0,0,225,0,135,0,44,0,179,0,0,0,210,0,0,0,74,0,38,0,0,0);
signal scenario_full  : scenario_type := (209,31,239,31,239,30,50,31,221,31,184,31,153,31,204,31,68,31,68,30,81,31,199,31,82,31,91,31,91,30,122,31,122,30,171,31,212,31,227,31,78,31,78,30,29,31,144,31,144,30,51,31,223,31,157,31,157,30,211,31,42,31,178,31,59,31,130,31,133,31,22,31,6,31,91,31,227,31,164,31,91,31,224,31,23,31,182,31,182,30,97,31,97,30,136,31,39,31,201,31,129,31,236,31,108,31,82,31,247,31,218,31,176,31,66,31,55,31,24,31,24,30,91,31,129,31,98,31,98,30,218,31,34,31,181,31,181,30,181,29,80,31,115,31,58,31,176,31,176,30,176,29,133,31,251,31,153,31,126,31,71,31,73,31,46,31,181,31,181,30,128,31,206,31,17,31,17,30,17,29,17,28,70,31,70,30,70,29,225,31,248,31,58,31,76,31,31,31,50,31,85,31,85,30,189,31,84,31,107,31,51,31,35,31,37,31,41,31,139,31,189,31,219,31,174,31,107,31,17,31,17,30,17,29,244,31,35,31,20,31,20,30,20,29,20,28,20,27,20,26,27,31,97,31,156,31,20,31,105,31,105,30,105,29,105,28,28,31,214,31,119,31,219,31,219,30,219,29,219,28,116,31,116,30,3,31,162,31,229,31,110,31,163,31,163,30,106,31,225,31,225,30,196,31,39,31,39,30,53,31,134,31,67,31,117,31,146,31,94,31,243,31,165,31,142,31,38,31,120,31,56,31,56,30,114,31,114,30,137,31,148,31,255,31,255,30,132,31,144,31,243,31,142,31,255,31,255,30,12,31,69,31,47,31,47,30,47,29,72,31,136,31,34,31,78,31,224,31,224,30,163,31,168,31,213,31,19,31,24,31,208,31,96,31,156,31,156,30,156,29,176,31,15,31,15,30,15,29,15,28,243,31,159,31,71,31,71,30,73,31,73,30,68,31,183,31,80,31,245,31,245,30,141,31,50,31,129,31,129,30,243,31,243,30,247,31,19,31,38,31,219,31,78,31,40,31,247,31,12,31,113,31,171,31,96,31,80,31,73,31,136,31,211,31,131,31,17,31,139,31,235,31,176,31,165,31,234,31,124,31,124,30,134,31,134,30,184,31,86,31,182,31,74,31,74,30,195,31,128,31,145,31,145,30,32,31,190,31,127,31,14,31,14,30,14,29,16,31,154,31,125,31,226,31,246,31,95,31,198,31,187,31,187,30,187,29,187,28,231,31,231,30,45,31,45,30,112,31,89,31,95,31,170,31,249,31,32,31,32,30,245,31,71,31,149,31,7,31,42,31,55,31,55,30,208,31,208,30,208,29,208,28,52,31,105,31,23,31,58,31,7,31,215,31,5,31,142,31,185,31,193,31,39,31,39,30,114,31,114,30,202,31,226,31,226,30,71,31,71,30,71,29,76,31,177,31,242,31,197,31,163,31,157,31,207,31,207,30,108,31,231,31,198,31,130,31,130,30,61,31,51,31,51,30,225,31,135,31,44,31,179,31,179,30,210,31,210,30,74,31,38,31,38,30);

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
