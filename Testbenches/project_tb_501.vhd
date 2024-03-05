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

constant SCENARIO_LENGTH : integer := 263;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (211,0,0,0,160,0,96,0,173,0,22,0,157,0,86,0,174,0,71,0,204,0,213,0,81,0,53,0,165,0,120,0,69,0,223,0,179,0,91,0,0,0,208,0,204,0,54,0,216,0,231,0,134,0,118,0,244,0,0,0,0,0,107,0,49,0,38,0,227,0,0,0,0,0,78,0,202,0,192,0,209,0,101,0,95,0,42,0,176,0,173,0,49,0,76,0,80,0,154,0,88,0,0,0,74,0,0,0,7,0,11,0,0,0,176,0,30,0,0,0,227,0,0,0,30,0,57,0,28,0,65,0,59,0,204,0,235,0,82,0,18,0,99,0,168,0,207,0,227,0,52,0,0,0,49,0,51,0,159,0,172,0,192,0,0,0,181,0,25,0,76,0,209,0,65,0,48,0,0,0,94,0,9,0,19,0,0,0,175,0,110,0,228,0,137,0,139,0,30,0,249,0,105,0,0,0,221,0,232,0,0,0,0,0,181,0,0,0,51,0,45,0,36,0,204,0,149,0,128,0,123,0,30,0,124,0,7,0,35,0,134,0,129,0,82,0,67,0,139,0,129,0,100,0,198,0,0,0,177,0,254,0,138,0,39,0,136,0,212,0,0,0,37,0,0,0,107,0,18,0,118,0,250,0,21,0,41,0,0,0,91,0,174,0,248,0,66,0,0,0,149,0,158,0,155,0,57,0,254,0,4,0,254,0,0,0,52,0,158,0,253,0,149,0,0,0,88,0,106,0,0,0,57,0,202,0,163,0,27,0,0,0,42,0,0,0,60,0,229,0,0,0,78,0,209,0,164,0,161,0,11,0,0,0,5,0,86,0,80,0,0,0,49,0,0,0,127,0,90,0,103,0,0,0,0,0,181,0,59,0,190,0,55,0,0,0,171,0,76,0,151,0,246,0,131,0,180,0,28,0,11,0,153,0,220,0,214,0,33,0,160,0,124,0,82,0,253,0,54,0,185,0,0,0,161,0,0,0,119,0,0,0,0,0,0,0,0,0,0,0,226,0,108,0,103,0,0,0,169,0,246,0,0,0,109,0,15,0,70,0,0,0,174,0,191,0,125,0,92,0,0,0,72,0,82,0,83,0,0,0,105,0,160,0,0,0,122,0,0,0,232,0,55,0,218,0,175,0,188,0,156,0,176,0,146,0,111,0,92,0,120,0,0,0,231,0);
signal scenario_full  : scenario_type := (211,31,211,30,160,31,96,31,173,31,22,31,157,31,86,31,174,31,71,31,204,31,213,31,81,31,53,31,165,31,120,31,69,31,223,31,179,31,91,31,91,30,208,31,204,31,54,31,216,31,231,31,134,31,118,31,244,31,244,30,244,29,107,31,49,31,38,31,227,31,227,30,227,29,78,31,202,31,192,31,209,31,101,31,95,31,42,31,176,31,173,31,49,31,76,31,80,31,154,31,88,31,88,30,74,31,74,30,7,31,11,31,11,30,176,31,30,31,30,30,227,31,227,30,30,31,57,31,28,31,65,31,59,31,204,31,235,31,82,31,18,31,99,31,168,31,207,31,227,31,52,31,52,30,49,31,51,31,159,31,172,31,192,31,192,30,181,31,25,31,76,31,209,31,65,31,48,31,48,30,94,31,9,31,19,31,19,30,175,31,110,31,228,31,137,31,139,31,30,31,249,31,105,31,105,30,221,31,232,31,232,30,232,29,181,31,181,30,51,31,45,31,36,31,204,31,149,31,128,31,123,31,30,31,124,31,7,31,35,31,134,31,129,31,82,31,67,31,139,31,129,31,100,31,198,31,198,30,177,31,254,31,138,31,39,31,136,31,212,31,212,30,37,31,37,30,107,31,18,31,118,31,250,31,21,31,41,31,41,30,91,31,174,31,248,31,66,31,66,30,149,31,158,31,155,31,57,31,254,31,4,31,254,31,254,30,52,31,158,31,253,31,149,31,149,30,88,31,106,31,106,30,57,31,202,31,163,31,27,31,27,30,42,31,42,30,60,31,229,31,229,30,78,31,209,31,164,31,161,31,11,31,11,30,5,31,86,31,80,31,80,30,49,31,49,30,127,31,90,31,103,31,103,30,103,29,181,31,59,31,190,31,55,31,55,30,171,31,76,31,151,31,246,31,131,31,180,31,28,31,11,31,153,31,220,31,214,31,33,31,160,31,124,31,82,31,253,31,54,31,185,31,185,30,161,31,161,30,119,31,119,30,119,29,119,28,119,27,119,26,226,31,108,31,103,31,103,30,169,31,246,31,246,30,109,31,15,31,70,31,70,30,174,31,191,31,125,31,92,31,92,30,72,31,82,31,83,31,83,30,105,31,160,31,160,30,122,31,122,30,232,31,55,31,218,31,175,31,188,31,156,31,176,31,146,31,111,31,92,31,120,31,120,30,231,31);

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
