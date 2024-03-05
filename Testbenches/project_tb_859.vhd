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

constant SCENARIO_LENGTH : integer := 332;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (218,0,177,0,0,0,100,0,248,0,0,0,1,0,29,0,85,0,22,0,31,0,0,0,104,0,86,0,241,0,111,0,226,0,245,0,205,0,0,0,246,0,185,0,0,0,89,0,0,0,126,0,198,0,39,0,55,0,2,0,126,0,187,0,235,0,0,0,100,0,197,0,198,0,15,0,0,0,234,0,105,0,236,0,0,0,170,0,0,0,195,0,142,0,117,0,220,0,79,0,223,0,20,0,132,0,0,0,0,0,168,0,224,0,63,0,0,0,76,0,96,0,7,0,0,0,22,0,92,0,82,0,247,0,234,0,0,0,66,0,0,0,194,0,211,0,185,0,0,0,183,0,0,0,0,0,23,0,248,0,165,0,66,0,124,0,0,0,106,0,181,0,0,0,101,0,205,0,0,0,219,0,0,0,171,0,0,0,81,0,170,0,0,0,254,0,0,0,0,0,94,0,0,0,0,0,146,0,237,0,185,0,0,0,153,0,181,0,50,0,39,0,30,0,0,0,123,0,80,0,195,0,76,0,55,0,13,0,105,0,165,0,68,0,253,0,0,0,0,0,224,0,25,0,223,0,17,0,25,0,14,0,62,0,252,0,210,0,245,0,0,0,49,0,255,0,0,0,45,0,134,0,199,0,184,0,37,0,143,0,61,0,0,0,0,0,203,0,255,0,139,0,168,0,78,0,182,0,23,0,176,0,134,0,228,0,0,0,129,0,56,0,18,0,110,0,139,0,85,0,0,0,0,0,163,0,0,0,0,0,0,0,195,0,207,0,67,0,0,0,201,0,98,0,142,0,74,0,0,0,71,0,166,0,161,0,219,0,0,0,140,0,0,0,0,0,0,0,212,0,117,0,249,0,246,0,181,0,110,0,23,0,223,0,177,0,100,0,94,0,217,0,0,0,0,0,255,0,0,0,41,0,235,0,86,0,62,0,4,0,0,0,0,0,59,0,151,0,240,0,0,0,106,0,101,0,40,0,240,0,132,0,236,0,72,0,68,0,88,0,223,0,0,0,94,0,0,0,18,0,37,0,41,0,73,0,74,0,235,0,0,0,99,0,159,0,237,0,0,0,185,0,153,0,181,0,134,0,145,0,245,0,0,0,5,0,16,0,105,0,247,0,38,0,0,0,120,0,99,0,131,0,101,0,229,0,214,0,0,0,127,0,0,0,66,0,254,0,0,0,0,0,0,0,203,0,131,0,26,0,177,0,239,0,0,0,98,0,182,0,14,0,90,0,232,0,187,0,0,0,177,0,63,0,0,0,118,0,0,0,152,0,121,0,234,0,238,0,0,0,67,0,167,0,239,0,140,0,0,0,54,0,0,0,92,0,223,0,229,0,88,0,187,0,236,0,136,0,226,0,143,0,7,0,53,0,240,0,95,0,173,0,8,0,0,0,4,0,64,0,43,0,0,0,145,0,0,0,228,0,178,0,0,0,0,0,181,0,0,0,236,0,94,0,13,0,0,0,192,0,0,0,33,0);
signal scenario_full  : scenario_type := (218,31,177,31,177,30,100,31,248,31,248,30,1,31,29,31,85,31,22,31,31,31,31,30,104,31,86,31,241,31,111,31,226,31,245,31,205,31,205,30,246,31,185,31,185,30,89,31,89,30,126,31,198,31,39,31,55,31,2,31,126,31,187,31,235,31,235,30,100,31,197,31,198,31,15,31,15,30,234,31,105,31,236,31,236,30,170,31,170,30,195,31,142,31,117,31,220,31,79,31,223,31,20,31,132,31,132,30,132,29,168,31,224,31,63,31,63,30,76,31,96,31,7,31,7,30,22,31,92,31,82,31,247,31,234,31,234,30,66,31,66,30,194,31,211,31,185,31,185,30,183,31,183,30,183,29,23,31,248,31,165,31,66,31,124,31,124,30,106,31,181,31,181,30,101,31,205,31,205,30,219,31,219,30,171,31,171,30,81,31,170,31,170,30,254,31,254,30,254,29,94,31,94,30,94,29,146,31,237,31,185,31,185,30,153,31,181,31,50,31,39,31,30,31,30,30,123,31,80,31,195,31,76,31,55,31,13,31,105,31,165,31,68,31,253,31,253,30,253,29,224,31,25,31,223,31,17,31,25,31,14,31,62,31,252,31,210,31,245,31,245,30,49,31,255,31,255,30,45,31,134,31,199,31,184,31,37,31,143,31,61,31,61,30,61,29,203,31,255,31,139,31,168,31,78,31,182,31,23,31,176,31,134,31,228,31,228,30,129,31,56,31,18,31,110,31,139,31,85,31,85,30,85,29,163,31,163,30,163,29,163,28,195,31,207,31,67,31,67,30,201,31,98,31,142,31,74,31,74,30,71,31,166,31,161,31,219,31,219,30,140,31,140,30,140,29,140,28,212,31,117,31,249,31,246,31,181,31,110,31,23,31,223,31,177,31,100,31,94,31,217,31,217,30,217,29,255,31,255,30,41,31,235,31,86,31,62,31,4,31,4,30,4,29,59,31,151,31,240,31,240,30,106,31,101,31,40,31,240,31,132,31,236,31,72,31,68,31,88,31,223,31,223,30,94,31,94,30,18,31,37,31,41,31,73,31,74,31,235,31,235,30,99,31,159,31,237,31,237,30,185,31,153,31,181,31,134,31,145,31,245,31,245,30,5,31,16,31,105,31,247,31,38,31,38,30,120,31,99,31,131,31,101,31,229,31,214,31,214,30,127,31,127,30,66,31,254,31,254,30,254,29,254,28,203,31,131,31,26,31,177,31,239,31,239,30,98,31,182,31,14,31,90,31,232,31,187,31,187,30,177,31,63,31,63,30,118,31,118,30,152,31,121,31,234,31,238,31,238,30,67,31,167,31,239,31,140,31,140,30,54,31,54,30,92,31,223,31,229,31,88,31,187,31,236,31,136,31,226,31,143,31,7,31,53,31,240,31,95,31,173,31,8,31,8,30,4,31,64,31,43,31,43,30,145,31,145,30,228,31,178,31,178,30,178,29,181,31,181,30,236,31,94,31,13,31,13,30,192,31,192,30,33,31);

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
