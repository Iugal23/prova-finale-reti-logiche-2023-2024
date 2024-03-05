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

constant SCENARIO_LENGTH : integer := 256;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (249,0,239,0,176,0,173,0,217,0,0,0,0,0,169,0,216,0,57,0,0,0,113,0,92,0,0,0,0,0,182,0,94,0,157,0,57,0,247,0,13,0,161,0,0,0,0,0,13,0,26,0,158,0,29,0,89,0,7,0,210,0,66,0,0,0,179,0,117,0,0,0,249,0,228,0,2,0,27,0,0,0,1,0,61,0,243,0,68,0,0,0,229,0,226,0,27,0,14,0,185,0,0,0,64,0,200,0,33,0,45,0,245,0,230,0,162,0,141,0,157,0,84,0,0,0,42,0,195,0,0,0,56,0,107,0,249,0,0,0,226,0,162,0,204,0,236,0,44,0,0,0,0,0,0,0,0,0,0,0,27,0,0,0,98,0,209,0,60,0,113,0,225,0,177,0,207,0,0,0,155,0,163,0,44,0,66,0,45,0,0,0,0,0,0,0,171,0,107,0,177,0,123,0,176,0,0,0,72,0,124,0,0,0,104,0,77,0,134,0,202,0,247,0,218,0,61,0,60,0,219,0,239,0,76,0,134,0,48,0,27,0,244,0,71,0,215,0,95,0,212,0,18,0,199,0,217,0,252,0,243,0,140,0,227,0,216,0,169,0,0,0,0,0,107,0,39,0,0,0,162,0,83,0,0,0,14,0,0,0,252,0,0,0,231,0,8,0,231,0,113,0,67,0,84,0,233,0,80,0,169,0,46,0,192,0,37,0,236,0,122,0,247,0,149,0,251,0,221,0,43,0,0,0,221,0,148,0,193,0,53,0,189,0,97,0,106,0,154,0,129,0,0,0,225,0,0,0,118,0,147,0,0,0,247,0,196,0,203,0,0,0,0,0,131,0,67,0,0,0,121,0,22,0,77,0,0,0,56,0,27,0,0,0,209,0,202,0,147,0,108,0,80,0,55,0,180,0,251,0,64,0,42,0,0,0,205,0,0,0,221,0,199,0,253,0,0,0,63,0,96,0,33,0,210,0,185,0,234,0,43,0,118,0,61,0,226,0,149,0,151,0,196,0,175,0,203,0,0,0,108,0,205,0,218,0,136,0,0,0,35,0,42,0,71,0,29,0,0,0,78,0,122,0,0,0,56,0,37,0,118,0,73,0,140,0,33,0,0,0,224,0,0,0,240,0,8,0,56,0,0,0);
signal scenario_full  : scenario_type := (249,31,239,31,176,31,173,31,217,31,217,30,217,29,169,31,216,31,57,31,57,30,113,31,92,31,92,30,92,29,182,31,94,31,157,31,57,31,247,31,13,31,161,31,161,30,161,29,13,31,26,31,158,31,29,31,89,31,7,31,210,31,66,31,66,30,179,31,117,31,117,30,249,31,228,31,2,31,27,31,27,30,1,31,61,31,243,31,68,31,68,30,229,31,226,31,27,31,14,31,185,31,185,30,64,31,200,31,33,31,45,31,245,31,230,31,162,31,141,31,157,31,84,31,84,30,42,31,195,31,195,30,56,31,107,31,249,31,249,30,226,31,162,31,204,31,236,31,44,31,44,30,44,29,44,28,44,27,44,26,27,31,27,30,98,31,209,31,60,31,113,31,225,31,177,31,207,31,207,30,155,31,163,31,44,31,66,31,45,31,45,30,45,29,45,28,171,31,107,31,177,31,123,31,176,31,176,30,72,31,124,31,124,30,104,31,77,31,134,31,202,31,247,31,218,31,61,31,60,31,219,31,239,31,76,31,134,31,48,31,27,31,244,31,71,31,215,31,95,31,212,31,18,31,199,31,217,31,252,31,243,31,140,31,227,31,216,31,169,31,169,30,169,29,107,31,39,31,39,30,162,31,83,31,83,30,14,31,14,30,252,31,252,30,231,31,8,31,231,31,113,31,67,31,84,31,233,31,80,31,169,31,46,31,192,31,37,31,236,31,122,31,247,31,149,31,251,31,221,31,43,31,43,30,221,31,148,31,193,31,53,31,189,31,97,31,106,31,154,31,129,31,129,30,225,31,225,30,118,31,147,31,147,30,247,31,196,31,203,31,203,30,203,29,131,31,67,31,67,30,121,31,22,31,77,31,77,30,56,31,27,31,27,30,209,31,202,31,147,31,108,31,80,31,55,31,180,31,251,31,64,31,42,31,42,30,205,31,205,30,221,31,199,31,253,31,253,30,63,31,96,31,33,31,210,31,185,31,234,31,43,31,118,31,61,31,226,31,149,31,151,31,196,31,175,31,203,31,203,30,108,31,205,31,218,31,136,31,136,30,35,31,42,31,71,31,29,31,29,30,78,31,122,31,122,30,56,31,37,31,118,31,73,31,140,31,33,31,33,30,224,31,224,30,240,31,8,31,56,31,56,30);

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
