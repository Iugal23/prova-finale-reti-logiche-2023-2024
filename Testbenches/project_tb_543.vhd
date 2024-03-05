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

constant SCENARIO_LENGTH : integer := 195;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (44,0,227,0,189,0,44,0,173,0,238,0,43,0,131,0,0,0,29,0,151,0,159,0,213,0,3,0,72,0,96,0,0,0,0,0,85,0,100,0,40,0,0,0,0,0,205,0,198,0,1,0,255,0,110,0,203,0,108,0,96,0,164,0,95,0,249,0,66,0,69,0,14,0,0,0,86,0,176,0,209,0,149,0,172,0,1,0,115,0,203,0,95,0,28,0,35,0,153,0,102,0,0,0,18,0,0,0,0,0,205,0,0,0,93,0,80,0,193,0,124,0,251,0,87,0,0,0,125,0,139,0,216,0,252,0,140,0,52,0,9,0,39,0,21,0,146,0,0,0,20,0,175,0,0,0,0,0,2,0,18,0,246,0,77,0,0,0,116,0,126,0,45,0,248,0,215,0,0,0,219,0,249,0,251,0,124,0,111,0,0,0,249,0,163,0,77,0,4,0,105,0,114,0,172,0,0,0,0,0,0,0,0,0,213,0,23,0,0,0,85,0,67,0,244,0,10,0,0,0,124,0,104,0,34,0,22,0,0,0,40,0,240,0,2,0,83,0,97,0,80,0,0,0,143,0,0,0,122,0,212,0,29,0,233,0,53,0,0,0,0,0,202,0,61,0,0,0,31,0,135,0,49,0,30,0,0,0,85,0,142,0,20,0,245,0,243,0,113,0,0,0,8,0,14,0,38,0,211,0,28,0,232,0,0,0,189,0,0,0,0,0,195,0,84,0,204,0,0,0,188,0,21,0,175,0,0,0,167,0,120,0,107,0,250,0,98,0,0,0,238,0,162,0,47,0,103,0,136,0,0,0,0,0,0,0,50,0,0,0,0,0,73,0,0,0,7,0,0,0,249,0,43,0,2,0,167,0,231,0);
signal scenario_full  : scenario_type := (44,31,227,31,189,31,44,31,173,31,238,31,43,31,131,31,131,30,29,31,151,31,159,31,213,31,3,31,72,31,96,31,96,30,96,29,85,31,100,31,40,31,40,30,40,29,205,31,198,31,1,31,255,31,110,31,203,31,108,31,96,31,164,31,95,31,249,31,66,31,69,31,14,31,14,30,86,31,176,31,209,31,149,31,172,31,1,31,115,31,203,31,95,31,28,31,35,31,153,31,102,31,102,30,18,31,18,30,18,29,205,31,205,30,93,31,80,31,193,31,124,31,251,31,87,31,87,30,125,31,139,31,216,31,252,31,140,31,52,31,9,31,39,31,21,31,146,31,146,30,20,31,175,31,175,30,175,29,2,31,18,31,246,31,77,31,77,30,116,31,126,31,45,31,248,31,215,31,215,30,219,31,249,31,251,31,124,31,111,31,111,30,249,31,163,31,77,31,4,31,105,31,114,31,172,31,172,30,172,29,172,28,172,27,213,31,23,31,23,30,85,31,67,31,244,31,10,31,10,30,124,31,104,31,34,31,22,31,22,30,40,31,240,31,2,31,83,31,97,31,80,31,80,30,143,31,143,30,122,31,212,31,29,31,233,31,53,31,53,30,53,29,202,31,61,31,61,30,31,31,135,31,49,31,30,31,30,30,85,31,142,31,20,31,245,31,243,31,113,31,113,30,8,31,14,31,38,31,211,31,28,31,232,31,232,30,189,31,189,30,189,29,195,31,84,31,204,31,204,30,188,31,21,31,175,31,175,30,167,31,120,31,107,31,250,31,98,31,98,30,238,31,162,31,47,31,103,31,136,31,136,30,136,29,136,28,50,31,50,30,50,29,73,31,73,30,7,31,7,30,249,31,43,31,2,31,167,31,231,31);

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
