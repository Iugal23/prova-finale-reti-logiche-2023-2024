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

constant SCENARIO_LENGTH : integer := 297;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (217,0,34,0,0,0,188,0,29,0,99,0,237,0,250,0,190,0,138,0,217,0,140,0,0,0,121,0,56,0,23,0,210,0,0,0,11,0,38,0,242,0,139,0,171,0,129,0,171,0,139,0,36,0,37,0,189,0,116,0,4,0,0,0,252,0,110,0,205,0,8,0,112,0,234,0,68,0,0,0,111,0,238,0,0,0,115,0,0,0,123,0,0,0,23,0,164,0,10,0,9,0,0,0,252,0,14,0,105,0,19,0,83,0,224,0,67,0,73,0,0,0,0,0,0,0,125,0,0,0,146,0,44,0,231,0,238,0,85,0,138,0,179,0,0,0,100,0,30,0,171,0,37,0,214,0,236,0,0,0,241,0,15,0,221,0,43,0,14,0,152,0,63,0,116,0,109,0,0,0,157,0,0,0,103,0,158,0,145,0,1,0,214,0,170,0,83,0,106,0,9,0,62,0,194,0,166,0,73,0,120,0,236,0,164,0,181,0,114,0,17,0,25,0,93,0,134,0,8,0,11,0,0,0,0,0,150,0,236,0,83,0,96,0,216,0,85,0,218,0,35,0,234,0,242,0,133,0,9,0,222,0,0,0,133,0,156,0,34,0,239,0,0,0,168,0,54,0,153,0,135,0,153,0,12,0,11,0,192,0,248,0,0,0,68,0,212,0,2,0,221,0,183,0,123,0,126,0,153,0,73,0,186,0,0,0,27,0,136,0,151,0,0,0,126,0,139,0,126,0,0,0,0,0,245,0,179,0,244,0,129,0,0,0,185,0,65,0,0,0,82,0,163,0,0,0,0,0,0,0,0,0,73,0,76,0,172,0,139,0,248,0,126,0,121,0,93,0,142,0,224,0,1,0,0,0,48,0,250,0,149,0,0,0,124,0,0,0,150,0,149,0,0,0,106,0,0,0,126,0,108,0,249,0,60,0,48,0,84,0,132,0,154,0,150,0,0,0,161,0,77,0,16,0,125,0,3,0,167,0,151,0,65,0,212,0,0,0,0,0,0,0,0,0,65,0,134,0,0,0,81,0,0,0,42,0,78,0,37,0,29,0,115,0,186,0,165,0,117,0,139,0,119,0,136,0,0,0,168,0,51,0,99,0,0,0,138,0,132,0,171,0,157,0,46,0,67,0,89,0,97,0,18,0,47,0,4,0,75,0,110,0,0,0,16,0,0,0,213,0,239,0,73,0,30,0,201,0,185,0,220,0,229,0,123,0,237,0,213,0,167,0,15,0,55,0,234,0,95,0,36,0,246,0,156,0,143,0,81,0,177,0,143,0,147,0,162,0,2,0,16,0,69,0,211,0,0,0,126,0,62,0,60,0);
signal scenario_full  : scenario_type := (217,31,34,31,34,30,188,31,29,31,99,31,237,31,250,31,190,31,138,31,217,31,140,31,140,30,121,31,56,31,23,31,210,31,210,30,11,31,38,31,242,31,139,31,171,31,129,31,171,31,139,31,36,31,37,31,189,31,116,31,4,31,4,30,252,31,110,31,205,31,8,31,112,31,234,31,68,31,68,30,111,31,238,31,238,30,115,31,115,30,123,31,123,30,23,31,164,31,10,31,9,31,9,30,252,31,14,31,105,31,19,31,83,31,224,31,67,31,73,31,73,30,73,29,73,28,125,31,125,30,146,31,44,31,231,31,238,31,85,31,138,31,179,31,179,30,100,31,30,31,171,31,37,31,214,31,236,31,236,30,241,31,15,31,221,31,43,31,14,31,152,31,63,31,116,31,109,31,109,30,157,31,157,30,103,31,158,31,145,31,1,31,214,31,170,31,83,31,106,31,9,31,62,31,194,31,166,31,73,31,120,31,236,31,164,31,181,31,114,31,17,31,25,31,93,31,134,31,8,31,11,31,11,30,11,29,150,31,236,31,83,31,96,31,216,31,85,31,218,31,35,31,234,31,242,31,133,31,9,31,222,31,222,30,133,31,156,31,34,31,239,31,239,30,168,31,54,31,153,31,135,31,153,31,12,31,11,31,192,31,248,31,248,30,68,31,212,31,2,31,221,31,183,31,123,31,126,31,153,31,73,31,186,31,186,30,27,31,136,31,151,31,151,30,126,31,139,31,126,31,126,30,126,29,245,31,179,31,244,31,129,31,129,30,185,31,65,31,65,30,82,31,163,31,163,30,163,29,163,28,163,27,73,31,76,31,172,31,139,31,248,31,126,31,121,31,93,31,142,31,224,31,1,31,1,30,48,31,250,31,149,31,149,30,124,31,124,30,150,31,149,31,149,30,106,31,106,30,126,31,108,31,249,31,60,31,48,31,84,31,132,31,154,31,150,31,150,30,161,31,77,31,16,31,125,31,3,31,167,31,151,31,65,31,212,31,212,30,212,29,212,28,212,27,65,31,134,31,134,30,81,31,81,30,42,31,78,31,37,31,29,31,115,31,186,31,165,31,117,31,139,31,119,31,136,31,136,30,168,31,51,31,99,31,99,30,138,31,132,31,171,31,157,31,46,31,67,31,89,31,97,31,18,31,47,31,4,31,75,31,110,31,110,30,16,31,16,30,213,31,239,31,73,31,30,31,201,31,185,31,220,31,229,31,123,31,237,31,213,31,167,31,15,31,55,31,234,31,95,31,36,31,246,31,156,31,143,31,81,31,177,31,143,31,147,31,162,31,2,31,16,31,69,31,211,31,211,30,126,31,62,31,60,31);

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
