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

constant SCENARIO_LENGTH : integer := 252;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,120,0,61,0,0,0,0,0,223,0,124,0,2,0,226,0,0,0,179,0,128,0,0,0,69,0,0,0,38,0,209,0,0,0,35,0,0,0,35,0,197,0,62,0,0,0,32,0,112,0,231,0,203,0,84,0,0,0,33,0,102,0,12,0,239,0,7,0,16,0,54,0,44,0,80,0,233,0,130,0,248,0,0,0,174,0,117,0,176,0,0,0,0,0,245,0,161,0,0,0,0,0,255,0,216,0,127,0,0,0,69,0,0,0,118,0,153,0,49,0,232,0,183,0,165,0,245,0,10,0,0,0,83,0,0,0,188,0,17,0,12,0,25,0,0,0,26,0,0,0,0,0,0,0,249,0,252,0,7,0,0,0,155,0,0,0,250,0,0,0,206,0,0,0,0,0,0,0,21,0,189,0,82,0,161,0,119,0,0,0,0,0,0,0,192,0,32,0,80,0,98,0,190,0,0,0,0,0,0,0,75,0,82,0,117,0,0,0,25,0,111,0,0,0,0,0,214,0,0,0,9,0,125,0,194,0,29,0,244,0,185,0,200,0,126,0,222,0,6,0,43,0,223,0,246,0,0,0,85,0,31,0,0,0,12,0,0,0,0,0,91,0,105,0,120,0,139,0,0,0,194,0,175,0,0,0,7,0,0,0,0,0,0,0,71,0,110,0,161,0,165,0,30,0,141,0,92,0,102,0,225,0,202,0,18,0,86,0,81,0,90,0,153,0,29,0,0,0,0,0,164,0,123,0,92,0,110,0,0,0,110,0,131,0,120,0,81,0,0,0,55,0,88,0,93,0,69,0,0,0,220,0,0,0,122,0,35,0,0,0,246,0,230,0,51,0,35,0,35,0,130,0,79,0,118,0,117,0,131,0,9,0,110,0,19,0,18,0,119,0,23,0,0,0,84,0,206,0,252,0,154,0,0,0,167,0,34,0,216,0,96,0,188,0,232,0,205,0,239,0,40,0,0,0,74,0,103,0,0,0,248,0,14,0,152,0,0,0,152,0,0,0,81,0,0,0,0,0,153,0,31,0,39,0,177,0,219,0,186,0,60,0,0,0,0,0,87,0,255,0,154,0,103,0,161,0,70,0,111,0,205,0,6,0,245,0,246,0,243,0,115,0);
signal scenario_full  : scenario_type := (0,0,120,31,61,31,61,30,61,29,223,31,124,31,2,31,226,31,226,30,179,31,128,31,128,30,69,31,69,30,38,31,209,31,209,30,35,31,35,30,35,31,197,31,62,31,62,30,32,31,112,31,231,31,203,31,84,31,84,30,33,31,102,31,12,31,239,31,7,31,16,31,54,31,44,31,80,31,233,31,130,31,248,31,248,30,174,31,117,31,176,31,176,30,176,29,245,31,161,31,161,30,161,29,255,31,216,31,127,31,127,30,69,31,69,30,118,31,153,31,49,31,232,31,183,31,165,31,245,31,10,31,10,30,83,31,83,30,188,31,17,31,12,31,25,31,25,30,26,31,26,30,26,29,26,28,249,31,252,31,7,31,7,30,155,31,155,30,250,31,250,30,206,31,206,30,206,29,206,28,21,31,189,31,82,31,161,31,119,31,119,30,119,29,119,28,192,31,32,31,80,31,98,31,190,31,190,30,190,29,190,28,75,31,82,31,117,31,117,30,25,31,111,31,111,30,111,29,214,31,214,30,9,31,125,31,194,31,29,31,244,31,185,31,200,31,126,31,222,31,6,31,43,31,223,31,246,31,246,30,85,31,31,31,31,30,12,31,12,30,12,29,91,31,105,31,120,31,139,31,139,30,194,31,175,31,175,30,7,31,7,30,7,29,7,28,71,31,110,31,161,31,165,31,30,31,141,31,92,31,102,31,225,31,202,31,18,31,86,31,81,31,90,31,153,31,29,31,29,30,29,29,164,31,123,31,92,31,110,31,110,30,110,31,131,31,120,31,81,31,81,30,55,31,88,31,93,31,69,31,69,30,220,31,220,30,122,31,35,31,35,30,246,31,230,31,51,31,35,31,35,31,130,31,79,31,118,31,117,31,131,31,9,31,110,31,19,31,18,31,119,31,23,31,23,30,84,31,206,31,252,31,154,31,154,30,167,31,34,31,216,31,96,31,188,31,232,31,205,31,239,31,40,31,40,30,74,31,103,31,103,30,248,31,14,31,152,31,152,30,152,31,152,30,81,31,81,30,81,29,153,31,31,31,39,31,177,31,219,31,186,31,60,31,60,30,60,29,87,31,255,31,154,31,103,31,161,31,70,31,111,31,205,31,6,31,245,31,246,31,243,31,115,31);

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
