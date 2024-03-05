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

constant SCENARIO_LENGTH : integer := 326;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (114,0,106,0,157,0,0,0,225,0,151,0,28,0,17,0,158,0,104,0,59,0,135,0,119,0,0,0,0,0,110,0,140,0,103,0,0,0,0,0,157,0,213,0,90,0,117,0,58,0,247,0,0,0,44,0,197,0,0,0,151,0,251,0,242,0,212,0,0,0,0,0,0,0,51,0,253,0,0,0,83,0,0,0,0,0,111,0,12,0,0,0,0,0,0,0,36,0,0,0,208,0,35,0,119,0,151,0,0,0,218,0,0,0,114,0,174,0,201,0,5,0,48,0,116,0,18,0,0,0,105,0,56,0,106,0,140,0,49,0,0,0,0,0,11,0,52,0,54,0,183,0,204,0,18,0,123,0,0,0,205,0,140,0,127,0,107,0,150,0,113,0,187,0,64,0,0,0,226,0,0,0,0,0,150,0,206,0,153,0,22,0,0,0,0,0,179,0,125,0,109,0,249,0,65,0,68,0,61,0,111,0,209,0,167,0,201,0,238,0,69,0,66,0,34,0,7,0,14,0,191,0,218,0,0,0,244,0,104,0,12,0,4,0,239,0,0,0,42,0,152,0,0,0,135,0,239,0,202,0,0,0,69,0,0,0,206,0,85,0,40,0,202,0,50,0,164,0,0,0,76,0,39,0,117,0,57,0,86,0,137,0,216,0,0,0,0,0,240,0,20,0,205,0,146,0,216,0,247,0,26,0,0,0,0,0,97,0,39,0,23,0,117,0,0,0,31,0,192,0,144,0,6,0,0,0,92,0,157,0,97,0,169,0,62,0,247,0,55,0,46,0,32,0,83,0,53,0,179,0,197,0,62,0,109,0,221,0,46,0,0,0,78,0,43,0,125,0,60,0,215,0,114,0,197,0,59,0,0,0,222,0,0,0,127,0,230,0,0,0,52,0,88,0,36,0,0,0,22,0,123,0,15,0,216,0,51,0,47,0,0,0,124,0,183,0,82,0,149,0,51,0,117,0,0,0,213,0,0,0,0,0,164,0,125,0,77,0,58,0,178,0,59,0,0,0,45,0,51,0,214,0,158,0,0,0,0,0,110,0,176,0,195,0,152,0,122,0,175,0,169,0,107,0,132,0,66,0,0,0,70,0,147,0,0,0,86,0,189,0,0,0,133,0,136,0,28,0,97,0,118,0,157,0,1,0,190,0,233,0,233,0,0,0,171,0,143,0,153,0,0,0,118,0,0,0,171,0,18,0,7,0,34,0,6,0,216,0,21,0,107,0,36,0,17,0,247,0,178,0,73,0,0,0,165,0,227,0,94,0,0,0,120,0,0,0,173,0,132,0,99,0,202,0,30,0,143,0,14,0,6,0,163,0,0,0,238,0,176,0,110,0,0,0,204,0,57,0,12,0,80,0,83,0,175,0,107,0,98,0,127,0,81,0,231,0,233,0,0,0,0,0,78,0,224,0,23,0,0,0,114,0,0,0,34,0,178,0,99,0,125,0);
signal scenario_full  : scenario_type := (114,31,106,31,157,31,157,30,225,31,151,31,28,31,17,31,158,31,104,31,59,31,135,31,119,31,119,30,119,29,110,31,140,31,103,31,103,30,103,29,157,31,213,31,90,31,117,31,58,31,247,31,247,30,44,31,197,31,197,30,151,31,251,31,242,31,212,31,212,30,212,29,212,28,51,31,253,31,253,30,83,31,83,30,83,29,111,31,12,31,12,30,12,29,12,28,36,31,36,30,208,31,35,31,119,31,151,31,151,30,218,31,218,30,114,31,174,31,201,31,5,31,48,31,116,31,18,31,18,30,105,31,56,31,106,31,140,31,49,31,49,30,49,29,11,31,52,31,54,31,183,31,204,31,18,31,123,31,123,30,205,31,140,31,127,31,107,31,150,31,113,31,187,31,64,31,64,30,226,31,226,30,226,29,150,31,206,31,153,31,22,31,22,30,22,29,179,31,125,31,109,31,249,31,65,31,68,31,61,31,111,31,209,31,167,31,201,31,238,31,69,31,66,31,34,31,7,31,14,31,191,31,218,31,218,30,244,31,104,31,12,31,4,31,239,31,239,30,42,31,152,31,152,30,135,31,239,31,202,31,202,30,69,31,69,30,206,31,85,31,40,31,202,31,50,31,164,31,164,30,76,31,39,31,117,31,57,31,86,31,137,31,216,31,216,30,216,29,240,31,20,31,205,31,146,31,216,31,247,31,26,31,26,30,26,29,97,31,39,31,23,31,117,31,117,30,31,31,192,31,144,31,6,31,6,30,92,31,157,31,97,31,169,31,62,31,247,31,55,31,46,31,32,31,83,31,53,31,179,31,197,31,62,31,109,31,221,31,46,31,46,30,78,31,43,31,125,31,60,31,215,31,114,31,197,31,59,31,59,30,222,31,222,30,127,31,230,31,230,30,52,31,88,31,36,31,36,30,22,31,123,31,15,31,216,31,51,31,47,31,47,30,124,31,183,31,82,31,149,31,51,31,117,31,117,30,213,31,213,30,213,29,164,31,125,31,77,31,58,31,178,31,59,31,59,30,45,31,51,31,214,31,158,31,158,30,158,29,110,31,176,31,195,31,152,31,122,31,175,31,169,31,107,31,132,31,66,31,66,30,70,31,147,31,147,30,86,31,189,31,189,30,133,31,136,31,28,31,97,31,118,31,157,31,1,31,190,31,233,31,233,31,233,30,171,31,143,31,153,31,153,30,118,31,118,30,171,31,18,31,7,31,34,31,6,31,216,31,21,31,107,31,36,31,17,31,247,31,178,31,73,31,73,30,165,31,227,31,94,31,94,30,120,31,120,30,173,31,132,31,99,31,202,31,30,31,143,31,14,31,6,31,163,31,163,30,238,31,176,31,110,31,110,30,204,31,57,31,12,31,80,31,83,31,175,31,107,31,98,31,127,31,81,31,231,31,233,31,233,30,233,29,78,31,224,31,23,31,23,30,114,31,114,30,34,31,178,31,99,31,125,31);

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
