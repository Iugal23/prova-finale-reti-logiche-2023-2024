-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_220 is
end project_tb_220;

architecture project_tb_arch_220 of project_tb_220 is
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

constant SCENARIO_LENGTH : integer := 393;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (65,0,25,0,0,0,84,0,7,0,157,0,197,0,86,0,185,0,55,0,74,0,72,0,30,0,142,0,208,0,30,0,70,0,0,0,26,0,0,0,84,0,158,0,0,0,88,0,0,0,240,0,215,0,98,0,41,0,0,0,0,0,107,0,169,0,217,0,230,0,244,0,0,0,231,0,0,0,88,0,103,0,37,0,218,0,233,0,75,0,68,0,216,0,6,0,121,0,0,0,0,0,0,0,20,0,0,0,154,0,129,0,0,0,97,0,6,0,168,0,0,0,62,0,178,0,156,0,207,0,42,0,64,0,93,0,87,0,196,0,177,0,0,0,67,0,0,0,110,0,190,0,29,0,143,0,172,0,89,0,234,0,0,0,216,0,166,0,49,0,72,0,190,0,56,0,170,0,0,0,224,0,186,0,122,0,58,0,152,0,45,0,166,0,248,0,52,0,184,0,18,0,44,0,128,0,194,0,0,0,0,0,206,0,72,0,199,0,145,0,70,0,199,0,117,0,209,0,247,0,111,0,60,0,190,0,192,0,0,0,0,0,252,0,87,0,226,0,0,0,213,0,97,0,100,0,229,0,104,0,14,0,43,0,153,0,0,0,179,0,172,0,195,0,124,0,104,0,250,0,156,0,16,0,53,0,129,0,0,0,109,0,80,0,0,0,88,0,86,0,182,0,21,0,229,0,0,0,0,0,129,0,103,0,134,0,158,0,251,0,0,0,0,0,0,0,230,0,79,0,205,0,0,0,0,0,247,0,58,0,194,0,238,0,176,0,175,0,205,0,138,0,220,0,0,0,121,0,59,0,126,0,121,0,252,0,129,0,89,0,86,0,0,0,167,0,59,0,86,0,29,0,168,0,58,0,255,0,244,0,146,0,165,0,0,0,217,0,62,0,43,0,188,0,0,0,0,0,54,0,0,0,187,0,0,0,0,0,33,0,0,0,53,0,213,0,92,0,138,0,182,0,246,0,49,0,0,0,144,0,9,0,129,0,79,0,73,0,0,0,153,0,212,0,254,0,52,0,158,0,0,0,0,0,158,0,78,0,228,0,109,0,92,0,0,0,103,0,163,0,184,0,99,0,118,0,0,0,76,0,140,0,140,0,93,0,229,0,0,0,61,0,0,0,48,0,178,0,138,0,90,0,92,0,74,0,0,0,200,0,120,0,203,0,0,0,109,0,186,0,222,0,0,0,127,0,101,0,13,0,0,0,161,0,187,0,219,0,25,0,157,0,119,0,0,0,55,0,186,0,2,0,104,0,0,0,238,0,32,0,71,0,0,0,193,0,22,0,28,0,138,0,47,0,125,0,228,0,16,0,130,0,171,0,0,0,109,0,0,0,47,0,176,0,148,0,75,0,0,0,0,0,197,0,6,0,178,0,70,0,99,0,236,0,148,0,147,0,0,0,169,0,59,0,0,0,100,0,0,0,0,0,232,0,25,0,156,0,90,0,83,0,38,0,45,0,224,0,202,0,228,0,216,0,66,0,154,0,111,0,0,0,84,0,220,0,252,0,192,0,40,0,88,0,0,0,219,0,0,0,170,0,36,0,189,0,236,0,21,0,235,0,153,0,107,0,0,0,0,0,0,0,105,0,37,0,35,0,35,0,120,0,61,0,255,0,133,0,0,0,162,0,235,0,236,0,79,0,229,0,106,0,59,0,0,0,118,0,0,0,20,0,237,0,0,0,186,0,208,0,214,0,104,0,97,0,0,0,251,0,47,0,0,0,161,0,79,0,34,0,121,0,244,0,184,0);
signal scenario_full  : scenario_type := (65,31,25,31,25,30,84,31,7,31,157,31,197,31,86,31,185,31,55,31,74,31,72,31,30,31,142,31,208,31,30,31,70,31,70,30,26,31,26,30,84,31,158,31,158,30,88,31,88,30,240,31,215,31,98,31,41,31,41,30,41,29,107,31,169,31,217,31,230,31,244,31,244,30,231,31,231,30,88,31,103,31,37,31,218,31,233,31,75,31,68,31,216,31,6,31,121,31,121,30,121,29,121,28,20,31,20,30,154,31,129,31,129,30,97,31,6,31,168,31,168,30,62,31,178,31,156,31,207,31,42,31,64,31,93,31,87,31,196,31,177,31,177,30,67,31,67,30,110,31,190,31,29,31,143,31,172,31,89,31,234,31,234,30,216,31,166,31,49,31,72,31,190,31,56,31,170,31,170,30,224,31,186,31,122,31,58,31,152,31,45,31,166,31,248,31,52,31,184,31,18,31,44,31,128,31,194,31,194,30,194,29,206,31,72,31,199,31,145,31,70,31,199,31,117,31,209,31,247,31,111,31,60,31,190,31,192,31,192,30,192,29,252,31,87,31,226,31,226,30,213,31,97,31,100,31,229,31,104,31,14,31,43,31,153,31,153,30,179,31,172,31,195,31,124,31,104,31,250,31,156,31,16,31,53,31,129,31,129,30,109,31,80,31,80,30,88,31,86,31,182,31,21,31,229,31,229,30,229,29,129,31,103,31,134,31,158,31,251,31,251,30,251,29,251,28,230,31,79,31,205,31,205,30,205,29,247,31,58,31,194,31,238,31,176,31,175,31,205,31,138,31,220,31,220,30,121,31,59,31,126,31,121,31,252,31,129,31,89,31,86,31,86,30,167,31,59,31,86,31,29,31,168,31,58,31,255,31,244,31,146,31,165,31,165,30,217,31,62,31,43,31,188,31,188,30,188,29,54,31,54,30,187,31,187,30,187,29,33,31,33,30,53,31,213,31,92,31,138,31,182,31,246,31,49,31,49,30,144,31,9,31,129,31,79,31,73,31,73,30,153,31,212,31,254,31,52,31,158,31,158,30,158,29,158,31,78,31,228,31,109,31,92,31,92,30,103,31,163,31,184,31,99,31,118,31,118,30,76,31,140,31,140,31,93,31,229,31,229,30,61,31,61,30,48,31,178,31,138,31,90,31,92,31,74,31,74,30,200,31,120,31,203,31,203,30,109,31,186,31,222,31,222,30,127,31,101,31,13,31,13,30,161,31,187,31,219,31,25,31,157,31,119,31,119,30,55,31,186,31,2,31,104,31,104,30,238,31,32,31,71,31,71,30,193,31,22,31,28,31,138,31,47,31,125,31,228,31,16,31,130,31,171,31,171,30,109,31,109,30,47,31,176,31,148,31,75,31,75,30,75,29,197,31,6,31,178,31,70,31,99,31,236,31,148,31,147,31,147,30,169,31,59,31,59,30,100,31,100,30,100,29,232,31,25,31,156,31,90,31,83,31,38,31,45,31,224,31,202,31,228,31,216,31,66,31,154,31,111,31,111,30,84,31,220,31,252,31,192,31,40,31,88,31,88,30,219,31,219,30,170,31,36,31,189,31,236,31,21,31,235,31,153,31,107,31,107,30,107,29,107,28,105,31,37,31,35,31,35,31,120,31,61,31,255,31,133,31,133,30,162,31,235,31,236,31,79,31,229,31,106,31,59,31,59,30,118,31,118,30,20,31,237,31,237,30,186,31,208,31,214,31,104,31,97,31,97,30,251,31,47,31,47,30,161,31,79,31,34,31,121,31,244,31,184,31);

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
