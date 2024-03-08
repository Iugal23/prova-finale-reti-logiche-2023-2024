-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_107 is
end project_tb_107;

architecture project_tb_arch_107 of project_tb_107 is
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

constant SCENARIO_LENGTH : integer := 158;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (221,0,72,0,0,0,183,0,155,0,0,0,0,0,199,0,0,0,0,0,0,0,124,0,0,0,164,0,136,0,0,0,57,0,0,0,7,0,53,0,43,0,107,0,205,0,0,0,12,0,145,0,128,0,51,0,210,0,118,0,173,0,221,0,42,0,0,0,74,0,226,0,11,0,10,0,240,0,19,0,181,0,178,0,0,0,224,0,0,0,163,0,171,0,19,0,110,0,215,0,179,0,117,0,211,0,129,0,92,0,248,0,34,0,0,0,212,0,0,0,0,0,73,0,225,0,121,0,81,0,10,0,148,0,46,0,17,0,0,0,102,0,0,0,244,0,255,0,14,0,27,0,243,0,16,0,8,0,0,0,0,0,81,0,0,0,0,0,0,0,199,0,30,0,94,0,51,0,60,0,84,0,0,0,8,0,53,0,0,0,185,0,107,0,0,0,55,0,133,0,0,0,142,0,77,0,63,0,28,0,0,0,111,0,42,0,202,0,73,0,21,0,94,0,152,0,237,0,0,0,0,0,0,0,1,0,51,0,50,0,250,0,145,0,121,0,144,0,28,0,204,0,244,0,144,0,41,0,175,0,61,0,237,0,0,0,0,0,37,0,15,0,30,0,0,0,205,0,51,0,133,0,205,0,63,0,27,0,89,0,13,0,139,0,9,0,148,0,0,0,0,0,96,0,42,0,0,0,0,0,114,0,136,0,69,0);
signal scenario_full  : scenario_type := (221,31,72,31,72,30,183,31,155,31,155,30,155,29,199,31,199,30,199,29,199,28,124,31,124,30,164,31,136,31,136,30,57,31,57,30,7,31,53,31,43,31,107,31,205,31,205,30,12,31,145,31,128,31,51,31,210,31,118,31,173,31,221,31,42,31,42,30,74,31,226,31,11,31,10,31,240,31,19,31,181,31,178,31,178,30,224,31,224,30,163,31,171,31,19,31,110,31,215,31,179,31,117,31,211,31,129,31,92,31,248,31,34,31,34,30,212,31,212,30,212,29,73,31,225,31,121,31,81,31,10,31,148,31,46,31,17,31,17,30,102,31,102,30,244,31,255,31,14,31,27,31,243,31,16,31,8,31,8,30,8,29,81,31,81,30,81,29,81,28,199,31,30,31,94,31,51,31,60,31,84,31,84,30,8,31,53,31,53,30,185,31,107,31,107,30,55,31,133,31,133,30,142,31,77,31,63,31,28,31,28,30,111,31,42,31,202,31,73,31,21,31,94,31,152,31,237,31,237,30,237,29,237,28,1,31,51,31,50,31,250,31,145,31,121,31,144,31,28,31,204,31,244,31,144,31,41,31,175,31,61,31,237,31,237,30,237,29,37,31,15,31,30,31,30,30,205,31,51,31,133,31,205,31,63,31,27,31,89,31,13,31,139,31,9,31,148,31,148,30,148,29,96,31,42,31,42,30,42,29,114,31,136,31,69,31);

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
