-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_924 is
end project_tb_924;

architecture project_tb_arch_924 of project_tb_924 is
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

constant SCENARIO_LENGTH : integer := 275;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (59,0,97,0,197,0,119,0,71,0,60,0,213,0,242,0,0,0,113,0,71,0,168,0,63,0,180,0,200,0,208,0,97,0,0,0,147,0,237,0,0,0,0,0,0,0,126,0,0,0,146,0,11,0,234,0,43,0,177,0,0,0,234,0,29,0,121,0,204,0,221,0,109,0,209,0,173,0,159,0,40,0,144,0,215,0,159,0,71,0,84,0,0,0,226,0,110,0,172,0,99,0,36,0,117,0,217,0,106,0,68,0,218,0,166,0,226,0,174,0,49,0,146,0,231,0,183,0,27,0,226,0,85,0,78,0,0,0,175,0,0,0,0,0,216,0,0,0,158,0,239,0,102,0,230,0,241,0,99,0,181,0,0,0,0,0,189,0,87,0,89,0,23,0,74,0,163,0,67,0,53,0,36,0,88,0,188,0,74,0,0,0,205,0,39,0,222,0,0,0,62,0,216,0,89,0,0,0,95,0,0,0,0,0,0,0,0,0,244,0,0,0,4,0,0,0,158,0,60,0,0,0,164,0,252,0,130,0,0,0,91,0,81,0,0,0,197,0,35,0,0,0,150,0,11,0,215,0,237,0,252,0,200,0,0,0,8,0,221,0,0,0,124,0,0,0,136,0,39,0,5,0,0,0,133,0,178,0,176,0,0,0,5,0,25,0,0,0,100,0,0,0,158,0,174,0,189,0,23,0,94,0,26,0,0,0,10,0,136,0,229,0,0,0,0,0,242,0,68,0,173,0,251,0,126,0,203,0,117,0,70,0,145,0,82,0,41,0,128,0,76,0,236,0,185,0,234,0,142,0,28,0,253,0,210,0,237,0,184,0,48,0,0,0,100,0,21,0,0,0,88,0,79,0,142,0,12,0,0,0,0,0,253,0,60,0,0,0,18,0,0,0,22,0,221,0,0,0,160,0,0,0,52,0,0,0,7,0,150,0,52,0,235,0,231,0,0,0,11,0,0,0,205,0,31,0,19,0,38,0,11,0,157,0,171,0,0,0,0,0,77,0,241,0,235,0,140,0,0,0,106,0,153,0,255,0,174,0,139,0,179,0,132,0,0,0,5,0,118,0,28,0,8,0,143,0,21,0,191,0,192,0,114,0,214,0,0,0,52,0,0,0,101,0,113,0,73,0,172,0,65,0,4,0,253,0,17,0,77,0,208,0,148,0,147,0,0,0,228,0,196,0,139,0,220,0,83,0,0,0,127,0,0,0,218,0,126,0,89,0);
signal scenario_full  : scenario_type := (59,31,97,31,197,31,119,31,71,31,60,31,213,31,242,31,242,30,113,31,71,31,168,31,63,31,180,31,200,31,208,31,97,31,97,30,147,31,237,31,237,30,237,29,237,28,126,31,126,30,146,31,11,31,234,31,43,31,177,31,177,30,234,31,29,31,121,31,204,31,221,31,109,31,209,31,173,31,159,31,40,31,144,31,215,31,159,31,71,31,84,31,84,30,226,31,110,31,172,31,99,31,36,31,117,31,217,31,106,31,68,31,218,31,166,31,226,31,174,31,49,31,146,31,231,31,183,31,27,31,226,31,85,31,78,31,78,30,175,31,175,30,175,29,216,31,216,30,158,31,239,31,102,31,230,31,241,31,99,31,181,31,181,30,181,29,189,31,87,31,89,31,23,31,74,31,163,31,67,31,53,31,36,31,88,31,188,31,74,31,74,30,205,31,39,31,222,31,222,30,62,31,216,31,89,31,89,30,95,31,95,30,95,29,95,28,95,27,244,31,244,30,4,31,4,30,158,31,60,31,60,30,164,31,252,31,130,31,130,30,91,31,81,31,81,30,197,31,35,31,35,30,150,31,11,31,215,31,237,31,252,31,200,31,200,30,8,31,221,31,221,30,124,31,124,30,136,31,39,31,5,31,5,30,133,31,178,31,176,31,176,30,5,31,25,31,25,30,100,31,100,30,158,31,174,31,189,31,23,31,94,31,26,31,26,30,10,31,136,31,229,31,229,30,229,29,242,31,68,31,173,31,251,31,126,31,203,31,117,31,70,31,145,31,82,31,41,31,128,31,76,31,236,31,185,31,234,31,142,31,28,31,253,31,210,31,237,31,184,31,48,31,48,30,100,31,21,31,21,30,88,31,79,31,142,31,12,31,12,30,12,29,253,31,60,31,60,30,18,31,18,30,22,31,221,31,221,30,160,31,160,30,52,31,52,30,7,31,150,31,52,31,235,31,231,31,231,30,11,31,11,30,205,31,31,31,19,31,38,31,11,31,157,31,171,31,171,30,171,29,77,31,241,31,235,31,140,31,140,30,106,31,153,31,255,31,174,31,139,31,179,31,132,31,132,30,5,31,118,31,28,31,8,31,143,31,21,31,191,31,192,31,114,31,214,31,214,30,52,31,52,30,101,31,113,31,73,31,172,31,65,31,4,31,253,31,17,31,77,31,208,31,148,31,147,31,147,30,228,31,196,31,139,31,220,31,83,31,83,30,127,31,127,30,218,31,126,31,89,31);

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
