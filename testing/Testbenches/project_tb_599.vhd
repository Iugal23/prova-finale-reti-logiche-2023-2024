-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_599 is
end project_tb_599;

architecture project_tb_arch_599 of project_tb_599 is
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

constant SCENARIO_LENGTH : integer := 280;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (242,0,217,0,185,0,55,0,0,0,0,0,136,0,0,0,241,0,20,0,245,0,138,0,177,0,8,0,0,0,250,0,152,0,222,0,134,0,155,0,65,0,0,0,167,0,168,0,90,0,167,0,0,0,173,0,200,0,0,0,154,0,0,0,207,0,102,0,12,0,0,0,0,0,147,0,150,0,7,0,44,0,227,0,255,0,0,0,0,0,233,0,252,0,192,0,235,0,26,0,153,0,121,0,15,0,40,0,95,0,18,0,233,0,13,0,105,0,72,0,203,0,196,0,254,0,168,0,0,0,76,0,141,0,32,0,144,0,0,0,243,0,0,0,0,0,167,0,25,0,0,0,106,0,248,0,72,0,0,0,218,0,113,0,9,0,229,0,108,0,218,0,150,0,252,0,178,0,104,0,147,0,104,0,217,0,93,0,205,0,0,0,137,0,179,0,94,0,140,0,139,0,42,0,43,0,50,0,4,0,80,0,37,0,0,0,128,0,176,0,4,0,80,0,237,0,42,0,0,0,147,0,222,0,66,0,0,0,26,0,231,0,251,0,5,0,178,0,88,0,242,0,30,0,0,0,27,0,99,0,0,0,54,0,213,0,1,0,87,0,76,0,228,0,225,0,130,0,0,0,167,0,171,0,250,0,111,0,235,0,31,0,212,0,63,0,125,0,0,0,13,0,155,0,64,0,154,0,56,0,160,0,208,0,203,0,0,0,188,0,242,0,10,0,100,0,225,0,115,0,228,0,107,0,229,0,139,0,229,0,161,0,216,0,175,0,0,0,162,0,207,0,38,0,119,0,0,0,249,0,37,0,115,0,21,0,10,0,81,0,245,0,31,0,253,0,0,0,0,0,208,0,87,0,206,0,0,0,43,0,35,0,139,0,142,0,105,0,215,0,91,0,106,0,214,0,29,0,31,0,110,0,70,0,182,0,58,0,217,0,74,0,213,0,0,0,140,0,116,0,0,0,241,0,0,0,218,0,102,0,0,0,217,0,95,0,4,0,94,0,148,0,81,0,110,0,164,0,157,0,44,0,231,0,27,0,0,0,20,0,15,0,0,0,46,0,96,0,163,0,0,0,23,0,95,0,99,0,215,0,52,0,54,0,206,0,157,0,28,0,229,0,199,0,111,0,113,0,0,0,77,0,190,0,6,0,0,0,106,0,0,0,249,0,0,0,108,0,9,0,23,0,0,0,0,0,148,0,0,0,43,0,0,0,184,0,245,0,25,0,204,0,247,0,64,0,152,0,234,0);
signal scenario_full  : scenario_type := (242,31,217,31,185,31,55,31,55,30,55,29,136,31,136,30,241,31,20,31,245,31,138,31,177,31,8,31,8,30,250,31,152,31,222,31,134,31,155,31,65,31,65,30,167,31,168,31,90,31,167,31,167,30,173,31,200,31,200,30,154,31,154,30,207,31,102,31,12,31,12,30,12,29,147,31,150,31,7,31,44,31,227,31,255,31,255,30,255,29,233,31,252,31,192,31,235,31,26,31,153,31,121,31,15,31,40,31,95,31,18,31,233,31,13,31,105,31,72,31,203,31,196,31,254,31,168,31,168,30,76,31,141,31,32,31,144,31,144,30,243,31,243,30,243,29,167,31,25,31,25,30,106,31,248,31,72,31,72,30,218,31,113,31,9,31,229,31,108,31,218,31,150,31,252,31,178,31,104,31,147,31,104,31,217,31,93,31,205,31,205,30,137,31,179,31,94,31,140,31,139,31,42,31,43,31,50,31,4,31,80,31,37,31,37,30,128,31,176,31,4,31,80,31,237,31,42,31,42,30,147,31,222,31,66,31,66,30,26,31,231,31,251,31,5,31,178,31,88,31,242,31,30,31,30,30,27,31,99,31,99,30,54,31,213,31,1,31,87,31,76,31,228,31,225,31,130,31,130,30,167,31,171,31,250,31,111,31,235,31,31,31,212,31,63,31,125,31,125,30,13,31,155,31,64,31,154,31,56,31,160,31,208,31,203,31,203,30,188,31,242,31,10,31,100,31,225,31,115,31,228,31,107,31,229,31,139,31,229,31,161,31,216,31,175,31,175,30,162,31,207,31,38,31,119,31,119,30,249,31,37,31,115,31,21,31,10,31,81,31,245,31,31,31,253,31,253,30,253,29,208,31,87,31,206,31,206,30,43,31,35,31,139,31,142,31,105,31,215,31,91,31,106,31,214,31,29,31,31,31,110,31,70,31,182,31,58,31,217,31,74,31,213,31,213,30,140,31,116,31,116,30,241,31,241,30,218,31,102,31,102,30,217,31,95,31,4,31,94,31,148,31,81,31,110,31,164,31,157,31,44,31,231,31,27,31,27,30,20,31,15,31,15,30,46,31,96,31,163,31,163,30,23,31,95,31,99,31,215,31,52,31,54,31,206,31,157,31,28,31,229,31,199,31,111,31,113,31,113,30,77,31,190,31,6,31,6,30,106,31,106,30,249,31,249,30,108,31,9,31,23,31,23,30,23,29,148,31,148,30,43,31,43,30,184,31,245,31,25,31,204,31,247,31,64,31,152,31,234,31);

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
