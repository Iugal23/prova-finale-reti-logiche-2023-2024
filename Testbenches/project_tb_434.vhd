-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_434 is
end project_tb_434;

architecture project_tb_arch_434 of project_tb_434 is
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

constant SCENARIO_LENGTH : integer := 480;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,204,0,108,0,0,0,76,0,0,0,235,0,0,0,132,0,54,0,101,0,11,0,0,0,64,0,219,0,27,0,0,0,146,0,23,0,80,0,187,0,138,0,0,0,202,0,137,0,195,0,253,0,68,0,232,0,103,0,68,0,25,0,47,0,174,0,210,0,65,0,0,0,36,0,53,0,110,0,0,0,138,0,231,0,153,0,251,0,0,0,0,0,0,0,169,0,89,0,0,0,78,0,190,0,219,0,0,0,79,0,142,0,244,0,0,0,234,0,219,0,0,0,82,0,208,0,0,0,29,0,192,0,201,0,0,0,30,0,157,0,149,0,0,0,229,0,76,0,0,0,7,0,13,0,85,0,193,0,116,0,208,0,0,0,94,0,200,0,216,0,29,0,16,0,64,0,83,0,0,0,122,0,159,0,136,0,75,0,58,0,223,0,27,0,21,0,170,0,0,0,188,0,55,0,76,0,0,0,203,0,200,0,25,0,128,0,105,0,15,0,254,0,182,0,234,0,0,0,47,0,0,0,63,0,13,0,196,0,36,0,231,0,118,0,100,0,142,0,215,0,78,0,110,0,105,0,0,0,238,0,102,0,226,0,48,0,0,0,224,0,46,0,210,0,145,0,160,0,0,0,26,0,138,0,176,0,56,0,148,0,102,0,250,0,14,0,228,0,102,0,8,0,149,0,0,0,29,0,47,0,80,0,0,0,0,0,96,0,117,0,0,0,116,0,43,0,163,0,115,0,80,0,42,0,93,0,60,0,44,0,231,0,0,0,196,0,9,0,243,0,0,0,115,0,241,0,37,0,163,0,207,0,0,0,172,0,0,0,3,0,0,0,179,0,103,0,0,0,0,0,195,0,0,0,181,0,103,0,138,0,246,0,77,0,0,0,0,0,139,0,96,0,14,0,25,0,231,0,0,0,39,0,0,0,155,0,112,0,59,0,109,0,246,0,151,0,75,0,0,0,87,0,92,0,24,0,0,0,15,0,0,0,88,0,128,0,85,0,16,0,63,0,36,0,205,0,44,0,108,0,253,0,115,0,24,0,144,0,115,0,126,0,0,0,139,0,34,0,221,0,229,0,76,0,89,0,68,0,85,0,163,0,0,0,124,0,0,0,239,0,6,0,16,0,29,0,0,0,151,0,0,0,94,0,85,0,234,0,247,0,21,0,220,0,62,0,0,0,102,0,52,0,6,0,135,0,17,0,250,0,0,0,26,0,80,0,176,0,255,0,8,0,164,0,166,0,216,0,212,0,34,0,139,0,145,0,223,0,254,0,9,0,133,0,250,0,154,0,251,0,223,0,23,0,0,0,126,0,67,0,240,0,33,0,202,0,36,0,213,0,0,0,0,0,246,0,221,0,187,0,240,0,0,0,205,0,154,0,88,0,161,0,198,0,32,0,0,0,0,0,59,0,135,0,93,0,70,0,112,0,204,0,34,0,96,0,191,0,251,0,0,0,82,0,202,0,0,0,131,0,0,0,245,0,91,0,140,0,238,0,157,0,112,0,163,0,123,0,2,0,0,0,0,0,181,0,0,0,37,0,38,0,110,0,0,0,0,0,48,0,0,0,0,0,160,0,52,0,126,0,65,0,60,0,198,0,38,0,81,0,128,0,192,0,98,0,9,0,127,0,132,0,132,0,65,0,0,0,0,0,45,0,146,0,0,0,194,0,85,0,79,0,19,0,23,0,0,0,137,0,0,0,63,0,203,0,225,0,134,0,132,0,122,0,160,0,0,0,43,0,72,0,240,0,197,0,135,0,90,0,0,0,60,0,0,0,0,0,109,0,195,0,255,0,193,0,37,0,110,0,0,0,235,0,135,0,65,0,93,0,117,0,7,0,0,0,15,0,59,0,180,0,248,0,211,0,0,0,0,0,207,0,0,0,248,0,131,0,150,0,250,0,0,0,174,0,17,0,36,0,197,0,45,0,152,0,131,0,150,0,0,0,187,0,51,0,13,0,179,0,118,0,176,0,64,0,0,0,35,0,87,0,0,0,16,0,68,0,184,0,196,0,76,0,111,0,251,0,222,0,82,0,110,0,225,0,240,0,0,0,15,0,196,0,0,0,226,0,131,0,0,0,17,0,115,0,18,0,87,0,200,0,180,0,180,0,86,0,0,0,148,0,0,0,49,0,60,0);
signal scenario_full  : scenario_type := (0,0,204,31,108,31,108,30,76,31,76,30,235,31,235,30,132,31,54,31,101,31,11,31,11,30,64,31,219,31,27,31,27,30,146,31,23,31,80,31,187,31,138,31,138,30,202,31,137,31,195,31,253,31,68,31,232,31,103,31,68,31,25,31,47,31,174,31,210,31,65,31,65,30,36,31,53,31,110,31,110,30,138,31,231,31,153,31,251,31,251,30,251,29,251,28,169,31,89,31,89,30,78,31,190,31,219,31,219,30,79,31,142,31,244,31,244,30,234,31,219,31,219,30,82,31,208,31,208,30,29,31,192,31,201,31,201,30,30,31,157,31,149,31,149,30,229,31,76,31,76,30,7,31,13,31,85,31,193,31,116,31,208,31,208,30,94,31,200,31,216,31,29,31,16,31,64,31,83,31,83,30,122,31,159,31,136,31,75,31,58,31,223,31,27,31,21,31,170,31,170,30,188,31,55,31,76,31,76,30,203,31,200,31,25,31,128,31,105,31,15,31,254,31,182,31,234,31,234,30,47,31,47,30,63,31,13,31,196,31,36,31,231,31,118,31,100,31,142,31,215,31,78,31,110,31,105,31,105,30,238,31,102,31,226,31,48,31,48,30,224,31,46,31,210,31,145,31,160,31,160,30,26,31,138,31,176,31,56,31,148,31,102,31,250,31,14,31,228,31,102,31,8,31,149,31,149,30,29,31,47,31,80,31,80,30,80,29,96,31,117,31,117,30,116,31,43,31,163,31,115,31,80,31,42,31,93,31,60,31,44,31,231,31,231,30,196,31,9,31,243,31,243,30,115,31,241,31,37,31,163,31,207,31,207,30,172,31,172,30,3,31,3,30,179,31,103,31,103,30,103,29,195,31,195,30,181,31,103,31,138,31,246,31,77,31,77,30,77,29,139,31,96,31,14,31,25,31,231,31,231,30,39,31,39,30,155,31,112,31,59,31,109,31,246,31,151,31,75,31,75,30,87,31,92,31,24,31,24,30,15,31,15,30,88,31,128,31,85,31,16,31,63,31,36,31,205,31,44,31,108,31,253,31,115,31,24,31,144,31,115,31,126,31,126,30,139,31,34,31,221,31,229,31,76,31,89,31,68,31,85,31,163,31,163,30,124,31,124,30,239,31,6,31,16,31,29,31,29,30,151,31,151,30,94,31,85,31,234,31,247,31,21,31,220,31,62,31,62,30,102,31,52,31,6,31,135,31,17,31,250,31,250,30,26,31,80,31,176,31,255,31,8,31,164,31,166,31,216,31,212,31,34,31,139,31,145,31,223,31,254,31,9,31,133,31,250,31,154,31,251,31,223,31,23,31,23,30,126,31,67,31,240,31,33,31,202,31,36,31,213,31,213,30,213,29,246,31,221,31,187,31,240,31,240,30,205,31,154,31,88,31,161,31,198,31,32,31,32,30,32,29,59,31,135,31,93,31,70,31,112,31,204,31,34,31,96,31,191,31,251,31,251,30,82,31,202,31,202,30,131,31,131,30,245,31,91,31,140,31,238,31,157,31,112,31,163,31,123,31,2,31,2,30,2,29,181,31,181,30,37,31,38,31,110,31,110,30,110,29,48,31,48,30,48,29,160,31,52,31,126,31,65,31,60,31,198,31,38,31,81,31,128,31,192,31,98,31,9,31,127,31,132,31,132,31,65,31,65,30,65,29,45,31,146,31,146,30,194,31,85,31,79,31,19,31,23,31,23,30,137,31,137,30,63,31,203,31,225,31,134,31,132,31,122,31,160,31,160,30,43,31,72,31,240,31,197,31,135,31,90,31,90,30,60,31,60,30,60,29,109,31,195,31,255,31,193,31,37,31,110,31,110,30,235,31,135,31,65,31,93,31,117,31,7,31,7,30,15,31,59,31,180,31,248,31,211,31,211,30,211,29,207,31,207,30,248,31,131,31,150,31,250,31,250,30,174,31,17,31,36,31,197,31,45,31,152,31,131,31,150,31,150,30,187,31,51,31,13,31,179,31,118,31,176,31,64,31,64,30,35,31,87,31,87,30,16,31,68,31,184,31,196,31,76,31,111,31,251,31,222,31,82,31,110,31,225,31,240,31,240,30,15,31,196,31,196,30,226,31,131,31,131,30,17,31,115,31,18,31,87,31,200,31,180,31,180,31,86,31,86,30,148,31,148,30,49,31,60,31);

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
