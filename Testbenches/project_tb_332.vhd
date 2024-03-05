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

constant SCENARIO_LENGTH : integer := 228;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (88,0,104,0,106,0,17,0,17,0,236,0,39,0,197,0,97,0,87,0,115,0,0,0,14,0,0,0,0,0,11,0,222,0,0,0,0,0,0,0,0,0,138,0,44,0,78,0,24,0,90,0,88,0,234,0,0,0,99,0,103,0,10,0,43,0,3,0,61,0,0,0,246,0,0,0,63,0,131,0,44,0,75,0,125,0,49,0,0,0,0,0,118,0,151,0,241,0,231,0,0,0,118,0,218,0,22,0,6,0,107,0,224,0,57,0,135,0,140,0,212,0,64,0,191,0,0,0,0,0,38,0,3,0,73,0,38,0,73,0,91,0,0,0,215,0,13,0,47,0,251,0,167,0,0,0,0,0,0,0,0,0,27,0,198,0,198,0,0,0,201,0,69,0,65,0,252,0,104,0,75,0,21,0,204,0,52,0,0,0,214,0,67,0,118,0,155,0,0,0,165,0,59,0,39,0,66,0,62,0,43,0,63,0,0,0,199,0,106,0,19,0,0,0,67,0,85,0,33,0,251,0,168,0,0,0,86,0,89,0,237,0,0,0,185,0,6,0,134,0,0,0,30,0,162,0,3,0,36,0,0,0,0,0,0,0,152,0,125,0,150,0,29,0,0,0,8,0,26,0,0,0,91,0,138,0,80,0,0,0,78,0,153,0,143,0,0,0,56,0,16,0,0,0,140,0,71,0,0,0,88,0,98,0,72,0,147,0,0,0,137,0,212,0,237,0,196,0,161,0,123,0,176,0,0,0,0,0,35,0,204,0,134,0,0,0,86,0,0,0,112,0,177,0,0,0,0,0,245,0,139,0,200,0,255,0,60,0,85,0,0,0,214,0,41,0,213,0,107,0,13,0,60,0,0,0,0,0,123,0,217,0,133,0,109,0,0,0,0,0,251,0,216,0,5,0,190,0,109,0,65,0,59,0,162,0,45,0,158,0,0,0,17,0,60,0,160,0,0,0,9,0,176,0,78,0,53,0,159,0,218,0,192,0,0,0,0,0,54,0,0,0,0,0,0,0);
signal scenario_full  : scenario_type := (88,31,104,31,106,31,17,31,17,31,236,31,39,31,197,31,97,31,87,31,115,31,115,30,14,31,14,30,14,29,11,31,222,31,222,30,222,29,222,28,222,27,138,31,44,31,78,31,24,31,90,31,88,31,234,31,234,30,99,31,103,31,10,31,43,31,3,31,61,31,61,30,246,31,246,30,63,31,131,31,44,31,75,31,125,31,49,31,49,30,49,29,118,31,151,31,241,31,231,31,231,30,118,31,218,31,22,31,6,31,107,31,224,31,57,31,135,31,140,31,212,31,64,31,191,31,191,30,191,29,38,31,3,31,73,31,38,31,73,31,91,31,91,30,215,31,13,31,47,31,251,31,167,31,167,30,167,29,167,28,167,27,27,31,198,31,198,31,198,30,201,31,69,31,65,31,252,31,104,31,75,31,21,31,204,31,52,31,52,30,214,31,67,31,118,31,155,31,155,30,165,31,59,31,39,31,66,31,62,31,43,31,63,31,63,30,199,31,106,31,19,31,19,30,67,31,85,31,33,31,251,31,168,31,168,30,86,31,89,31,237,31,237,30,185,31,6,31,134,31,134,30,30,31,162,31,3,31,36,31,36,30,36,29,36,28,152,31,125,31,150,31,29,31,29,30,8,31,26,31,26,30,91,31,138,31,80,31,80,30,78,31,153,31,143,31,143,30,56,31,16,31,16,30,140,31,71,31,71,30,88,31,98,31,72,31,147,31,147,30,137,31,212,31,237,31,196,31,161,31,123,31,176,31,176,30,176,29,35,31,204,31,134,31,134,30,86,31,86,30,112,31,177,31,177,30,177,29,245,31,139,31,200,31,255,31,60,31,85,31,85,30,214,31,41,31,213,31,107,31,13,31,60,31,60,30,60,29,123,31,217,31,133,31,109,31,109,30,109,29,251,31,216,31,5,31,190,31,109,31,65,31,59,31,162,31,45,31,158,31,158,30,17,31,60,31,160,31,160,30,9,31,176,31,78,31,53,31,159,31,218,31,192,31,192,30,192,29,54,31,54,30,54,29,54,28);

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
