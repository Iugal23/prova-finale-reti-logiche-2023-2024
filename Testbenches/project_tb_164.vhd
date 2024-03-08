-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_164 is
end project_tb_164;

architecture project_tb_arch_164 of project_tb_164 is
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

constant SCENARIO_LENGTH : integer := 384;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (253,0,93,0,185,0,105,0,59,0,176,0,251,0,0,0,253,0,38,0,123,0,178,0,240,0,219,0,0,0,101,0,74,0,32,0,0,0,83,0,0,0,103,0,0,0,175,0,0,0,104,0,25,0,75,0,0,0,32,0,132,0,176,0,0,0,24,0,22,0,0,0,53,0,189,0,182,0,0,0,141,0,88,0,95,0,86,0,155,0,68,0,201,0,103,0,74,0,97,0,39,0,251,0,65,0,254,0,156,0,0,0,101,0,0,0,255,0,119,0,142,0,0,0,101,0,139,0,224,0,210,0,107,0,25,0,99,0,233,0,60,0,144,0,116,0,73,0,44,0,205,0,113,0,151,0,119,0,40,0,192,0,30,0,255,0,0,0,166,0,81,0,162,0,96,0,86,0,0,0,0,0,91,0,13,0,73,0,139,0,94,0,248,0,110,0,0,0,236,0,0,0,119,0,0,0,0,0,117,0,13,0,237,0,81,0,251,0,33,0,0,0,176,0,243,0,59,0,0,0,19,0,37,0,162,0,183,0,255,0,96,0,184,0,101,0,0,0,47,0,7,0,0,0,112,0,218,0,216,0,195,0,21,0,48,0,90,0,0,0,0,0,24,0,129,0,0,0,0,0,15,0,0,0,138,0,34,0,242,0,90,0,116,0,12,0,142,0,149,0,100,0,56,0,50,0,0,0,79,0,103,0,0,0,235,0,137,0,165,0,128,0,0,0,59,0,141,0,0,0,0,0,145,0,242,0,228,0,20,0,95,0,61,0,26,0,7,0,89,0,226,0,0,0,40,0,107,0,0,0,137,0,172,0,0,0,50,0,168,0,176,0,97,0,102,0,34,0,112,0,122,0,0,0,15,0,34,0,57,0,139,0,59,0,170,0,52,0,0,0,55,0,93,0,205,0,139,0,83,0,166,0,131,0,0,0,43,0,119,0,110,0,11,0,0,0,57,0,170,0,232,0,0,0,220,0,103,0,165,0,9,0,31,0,173,0,54,0,159,0,240,0,207,0,173,0,174,0,186,0,0,0,242,0,0,0,156,0,0,0,102,0,106,0,113,0,0,0,205,0,151,0,0,0,66,0,141,0,41,0,165,0,0,0,0,0,134,0,161,0,172,0,37,0,242,0,86,0,219,0,138,0,139,0,10,0,0,0,10,0,60,0,0,0,178,0,0,0,82,0,228,0,35,0,34,0,175,0,0,0,212,0,79,0,138,0,0,0,139,0,165,0,218,0,106,0,0,0,137,0,214,0,244,0,154,0,35,0,112,0,95,0,240,0,0,0,0,0,76,0,0,0,180,0,180,0,114,0,0,0,132,0,246,0,187,0,0,0,0,0,22,0,0,0,132,0,172,0,0,0,176,0,103,0,180,0,0,0,51,0,20,0,190,0,52,0,243,0,107,0,233,0,146,0,71,0,38,0,0,0,37,0,0,0,1,0,96,0,20,0,251,0,244,0,0,0,171,0,125,0,194,0,0,0,0,0,15,0,51,0,135,0,116,0,172,0,0,0,36,0,70,0,0,0,7,0,73,0,230,0,82,0,129,0,0,0,0,0,234,0,0,0,221,0,240,0,0,0,0,0,135,0,0,0,0,0,219,0,44,0,0,0,147,0,139,0,97,0,216,0,105,0,134,0,42,0,64,0,0,0,107,0,202,0,0,0,127,0,218,0,97,0,198,0,82,0,0,0,103,0,0,0,109,0,72,0,6,0);
signal scenario_full  : scenario_type := (253,31,93,31,185,31,105,31,59,31,176,31,251,31,251,30,253,31,38,31,123,31,178,31,240,31,219,31,219,30,101,31,74,31,32,31,32,30,83,31,83,30,103,31,103,30,175,31,175,30,104,31,25,31,75,31,75,30,32,31,132,31,176,31,176,30,24,31,22,31,22,30,53,31,189,31,182,31,182,30,141,31,88,31,95,31,86,31,155,31,68,31,201,31,103,31,74,31,97,31,39,31,251,31,65,31,254,31,156,31,156,30,101,31,101,30,255,31,119,31,142,31,142,30,101,31,139,31,224,31,210,31,107,31,25,31,99,31,233,31,60,31,144,31,116,31,73,31,44,31,205,31,113,31,151,31,119,31,40,31,192,31,30,31,255,31,255,30,166,31,81,31,162,31,96,31,86,31,86,30,86,29,91,31,13,31,73,31,139,31,94,31,248,31,110,31,110,30,236,31,236,30,119,31,119,30,119,29,117,31,13,31,237,31,81,31,251,31,33,31,33,30,176,31,243,31,59,31,59,30,19,31,37,31,162,31,183,31,255,31,96,31,184,31,101,31,101,30,47,31,7,31,7,30,112,31,218,31,216,31,195,31,21,31,48,31,90,31,90,30,90,29,24,31,129,31,129,30,129,29,15,31,15,30,138,31,34,31,242,31,90,31,116,31,12,31,142,31,149,31,100,31,56,31,50,31,50,30,79,31,103,31,103,30,235,31,137,31,165,31,128,31,128,30,59,31,141,31,141,30,141,29,145,31,242,31,228,31,20,31,95,31,61,31,26,31,7,31,89,31,226,31,226,30,40,31,107,31,107,30,137,31,172,31,172,30,50,31,168,31,176,31,97,31,102,31,34,31,112,31,122,31,122,30,15,31,34,31,57,31,139,31,59,31,170,31,52,31,52,30,55,31,93,31,205,31,139,31,83,31,166,31,131,31,131,30,43,31,119,31,110,31,11,31,11,30,57,31,170,31,232,31,232,30,220,31,103,31,165,31,9,31,31,31,173,31,54,31,159,31,240,31,207,31,173,31,174,31,186,31,186,30,242,31,242,30,156,31,156,30,102,31,106,31,113,31,113,30,205,31,151,31,151,30,66,31,141,31,41,31,165,31,165,30,165,29,134,31,161,31,172,31,37,31,242,31,86,31,219,31,138,31,139,31,10,31,10,30,10,31,60,31,60,30,178,31,178,30,82,31,228,31,35,31,34,31,175,31,175,30,212,31,79,31,138,31,138,30,139,31,165,31,218,31,106,31,106,30,137,31,214,31,244,31,154,31,35,31,112,31,95,31,240,31,240,30,240,29,76,31,76,30,180,31,180,31,114,31,114,30,132,31,246,31,187,31,187,30,187,29,22,31,22,30,132,31,172,31,172,30,176,31,103,31,180,31,180,30,51,31,20,31,190,31,52,31,243,31,107,31,233,31,146,31,71,31,38,31,38,30,37,31,37,30,1,31,96,31,20,31,251,31,244,31,244,30,171,31,125,31,194,31,194,30,194,29,15,31,51,31,135,31,116,31,172,31,172,30,36,31,70,31,70,30,7,31,73,31,230,31,82,31,129,31,129,30,129,29,234,31,234,30,221,31,240,31,240,30,240,29,135,31,135,30,135,29,219,31,44,31,44,30,147,31,139,31,97,31,216,31,105,31,134,31,42,31,64,31,64,30,107,31,202,31,202,30,127,31,218,31,97,31,198,31,82,31,82,30,103,31,103,30,109,31,72,31,6,31);

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
