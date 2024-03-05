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

constant SCENARIO_LENGTH : integer := 325;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (125,0,0,0,222,0,0,0,206,0,212,0,0,0,64,0,0,0,0,0,229,0,5,0,0,0,147,0,0,0,146,0,225,0,249,0,151,0,123,0,0,0,73,0,251,0,11,0,49,0,0,0,0,0,0,0,32,0,161,0,227,0,17,0,249,0,242,0,92,0,67,0,226,0,24,0,103,0,0,0,254,0,0,0,0,0,132,0,81,0,0,0,0,0,196,0,255,0,243,0,0,0,0,0,51,0,242,0,19,0,47,0,0,0,62,0,106,0,113,0,72,0,0,0,13,0,1,0,236,0,32,0,137,0,0,0,142,0,12,0,89,0,126,0,227,0,0,0,125,0,160,0,237,0,78,0,228,0,157,0,19,0,219,0,250,0,43,0,250,0,0,0,103,0,0,0,136,0,55,0,29,0,84,0,0,0,0,0,90,0,105,0,138,0,0,0,189,0,52,0,208,0,190,0,79,0,42,0,68,0,9,0,234,0,0,0,104,0,202,0,0,0,240,0,255,0,39,0,0,0,233,0,237,0,13,0,101,0,26,0,98,0,103,0,19,0,0,0,0,0,0,0,222,0,63,0,173,0,0,0,216,0,138,0,98,0,15,0,0,0,13,0,60,0,233,0,107,0,0,0,164,0,194,0,0,0,129,0,19,0,74,0,71,0,0,0,100,0,175,0,166,0,87,0,82,0,117,0,70,0,148,0,23,0,46,0,227,0,178,0,87,0,72,0,250,0,221,0,25,0,166,0,169,0,81,0,41,0,0,0,85,0,28,0,234,0,250,0,0,0,25,0,64,0,0,0,86,0,173,0,232,0,0,0,65,0,185,0,88,0,138,0,16,0,175,0,200,0,159,0,149,0,105,0,0,0,116,0,199,0,133,0,230,0,47,0,0,0,27,0,200,0,9,0,0,0,172,0,118,0,137,0,133,0,40,0,55,0,231,0,147,0,121,0,0,0,208,0,130,0,116,0,3,0,0,0,0,0,79,0,210,0,239,0,19,0,0,0,0,0,0,0,40,0,95,0,21,0,186,0,19,0,80,0,0,0,121,0,155,0,208,0,89,0,136,0,0,0,216,0,0,0,145,0,221,0,4,0,0,0,253,0,16,0,32,0,0,0,133,0,239,0,101,0,254,0,0,0,0,0,232,0,0,0,0,0,223,0,0,0,180,0,131,0,179,0,180,0,0,0,1,0,57,0,132,0,0,0,0,0,250,0,170,0,191,0,74,0,0,0,63,0,207,0,142,0,169,0,0,0,17,0,0,0,0,0,238,0,186,0,34,0,0,0,38,0,159,0,224,0,166,0,199,0,102,0,159,0,153,0,54,0,83,0,23,0,21,0,244,0,233,0,221,0,0,0,103,0,236,0,70,0,247,0,220,0,0,0,45,0,131,0,232,0,237,0,187,0,0,0,0,0,197,0,11,0,51,0,0,0,61,0,99,0,186,0,30,0,162,0);
signal scenario_full  : scenario_type := (125,31,125,30,222,31,222,30,206,31,212,31,212,30,64,31,64,30,64,29,229,31,5,31,5,30,147,31,147,30,146,31,225,31,249,31,151,31,123,31,123,30,73,31,251,31,11,31,49,31,49,30,49,29,49,28,32,31,161,31,227,31,17,31,249,31,242,31,92,31,67,31,226,31,24,31,103,31,103,30,254,31,254,30,254,29,132,31,81,31,81,30,81,29,196,31,255,31,243,31,243,30,243,29,51,31,242,31,19,31,47,31,47,30,62,31,106,31,113,31,72,31,72,30,13,31,1,31,236,31,32,31,137,31,137,30,142,31,12,31,89,31,126,31,227,31,227,30,125,31,160,31,237,31,78,31,228,31,157,31,19,31,219,31,250,31,43,31,250,31,250,30,103,31,103,30,136,31,55,31,29,31,84,31,84,30,84,29,90,31,105,31,138,31,138,30,189,31,52,31,208,31,190,31,79,31,42,31,68,31,9,31,234,31,234,30,104,31,202,31,202,30,240,31,255,31,39,31,39,30,233,31,237,31,13,31,101,31,26,31,98,31,103,31,19,31,19,30,19,29,19,28,222,31,63,31,173,31,173,30,216,31,138,31,98,31,15,31,15,30,13,31,60,31,233,31,107,31,107,30,164,31,194,31,194,30,129,31,19,31,74,31,71,31,71,30,100,31,175,31,166,31,87,31,82,31,117,31,70,31,148,31,23,31,46,31,227,31,178,31,87,31,72,31,250,31,221,31,25,31,166,31,169,31,81,31,41,31,41,30,85,31,28,31,234,31,250,31,250,30,25,31,64,31,64,30,86,31,173,31,232,31,232,30,65,31,185,31,88,31,138,31,16,31,175,31,200,31,159,31,149,31,105,31,105,30,116,31,199,31,133,31,230,31,47,31,47,30,27,31,200,31,9,31,9,30,172,31,118,31,137,31,133,31,40,31,55,31,231,31,147,31,121,31,121,30,208,31,130,31,116,31,3,31,3,30,3,29,79,31,210,31,239,31,19,31,19,30,19,29,19,28,40,31,95,31,21,31,186,31,19,31,80,31,80,30,121,31,155,31,208,31,89,31,136,31,136,30,216,31,216,30,145,31,221,31,4,31,4,30,253,31,16,31,32,31,32,30,133,31,239,31,101,31,254,31,254,30,254,29,232,31,232,30,232,29,223,31,223,30,180,31,131,31,179,31,180,31,180,30,1,31,57,31,132,31,132,30,132,29,250,31,170,31,191,31,74,31,74,30,63,31,207,31,142,31,169,31,169,30,17,31,17,30,17,29,238,31,186,31,34,31,34,30,38,31,159,31,224,31,166,31,199,31,102,31,159,31,153,31,54,31,83,31,23,31,21,31,244,31,233,31,221,31,221,30,103,31,236,31,70,31,247,31,220,31,220,30,45,31,131,31,232,31,237,31,187,31,187,30,187,29,197,31,11,31,51,31,51,30,61,31,99,31,186,31,30,31,162,31);

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
