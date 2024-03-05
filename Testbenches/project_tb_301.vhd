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

constant SCENARIO_LENGTH : integer := 530;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,33,0,222,0,63,0,197,0,169,0,169,0,236,0,195,0,101,0,13,0,0,0,250,0,0,0,76,0,36,0,3,0,0,0,0,0,179,0,233,0,0,0,9,0,0,0,207,0,75,0,0,0,143,0,11,0,111,0,11,0,152,0,16,0,48,0,0,0,0,0,110,0,174,0,0,0,46,0,0,0,159,0,0,0,164,0,142,0,176,0,0,0,193,0,86,0,89,0,113,0,130,0,238,0,143,0,171,0,60,0,0,0,144,0,158,0,229,0,252,0,14,0,190,0,29,0,72,0,0,0,0,0,192,0,188,0,213,0,234,0,159,0,121,0,166,0,253,0,201,0,105,0,49,0,176,0,124,0,105,0,160,0,201,0,48,0,142,0,0,0,235,0,34,0,124,0,215,0,165,0,163,0,210,0,201,0,232,0,0,0,244,0,0,0,0,0,180,0,238,0,245,0,0,0,0,0,238,0,0,0,0,0,0,0,220,0,12,0,0,0,0,0,0,0,23,0,116,0,8,0,102,0,244,0,157,0,185,0,2,0,242,0,229,0,165,0,0,0,138,0,62,0,16,0,181,0,150,0,0,0,68,0,193,0,34,0,212,0,255,0,179,0,248,0,65,0,185,0,243,0,104,0,65,0,0,0,85,0,205,0,222,0,193,0,48,0,171,0,0,0,0,0,111,0,120,0,27,0,141,0,117,0,252,0,19,0,0,0,216,0,0,0,0,0,208,0,139,0,109,0,15,0,143,0,200,0,137,0,0,0,27,0,71,0,29,0,6,0,66,0,243,0,251,0,204,0,208,0,0,0,147,0,133,0,140,0,125,0,107,0,0,0,0,0,18,0,61,0,0,0,243,0,100,0,0,0,243,0,164,0,0,0,213,0,154,0,113,0,0,0,241,0,0,0,65,0,0,0,150,0,5,0,135,0,0,0,139,0,239,0,239,0,172,0,0,0,36,0,104,0,82,0,212,0,0,0,0,0,142,0,88,0,39,0,6,0,187,0,78,0,252,0,38,0,16,0,37,0,21,0,35,0,248,0,73,0,187,0,9,0,0,0,241,0,196,0,200,0,0,0,0,0,2,0,112,0,52,0,0,0,98,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,158,0,43,0,114,0,247,0,75,0,0,0,0,0,233,0,202,0,12,0,0,0,251,0,81,0,0,0,0,0,0,0,0,0,240,0,169,0,0,0,153,0,0,0,217,0,114,0,248,0,183,0,166,0,185,0,1,0,0,0,188,0,29,0,69,0,201,0,67,0,109,0,0,0,23,0,51,0,207,0,42,0,91,0,79,0,133,0,0,0,0,0,80,0,219,0,22,0,132,0,0,0,90,0,0,0,83,0,0,0,0,0,39,0,67,0,99,0,151,0,24,0,132,0,124,0,2,0,98,0,8,0,84,0,113,0,147,0,1,0,240,0,54,0,0,0,175,0,0,0,237,0,0,0,31,0,102,0,163,0,74,0,190,0,218,0,151,0,12,0,0,0,138,0,80,0,55,0,47,0,86,0,0,0,59,0,0,0,24,0,219,0,0,0,44,0,170,0,161,0,73,0,0,0,195,0,0,0,30,0,133,0,112,0,117,0,0,0,94,0,207,0,216,0,42,0,228,0,0,0,63,0,254,0,181,0,60,0,80,0,79,0,5,0,226,0,223,0,0,0,0,0,239,0,103,0,0,0,193,0,220,0,93,0,0,0,39,0,214,0,241,0,109,0,0,0,241,0,137,0,105,0,221,0,64,0,188,0,74,0,51,0,127,0,217,0,71,0,49,0,15,0,62,0,35,0,169,0,174,0,0,0,182,0,3,0,184,0,23,0,0,0,216,0,179,0,255,0,0,0,83,0,176,0,63,0,232,0,64,0,130,0,113,0,236,0,2,0,61,0,34,0,0,0,171,0,134,0,1,0,250,0,20,0,74,0,0,0,147,0,182,0,0,0,0,0,170,0,121,0,0,0,0,0,159,0,0,0,203,0,172,0,111,0,0,0,64,0,172,0,248,0,244,0,9,0,233,0,147,0,128,0,0,0,66,0,0,0,210,0,107,0,44,0,0,0,192,0,155,0,0,0,88,0,0,0,45,0,223,0,26,0,67,0,0,0,164,0,22,0,235,0,0,0,57,0,197,0,214,0,0,0,162,0,22,0,34,0,0,0,151,0,64,0,75,0,144,0,0,0,36,0,25,0,90,0,131,0,210,0,160,0,0,0,55,0,187,0,117,0,56,0,234,0,70,0,165,0,86,0,0,0,17,0,194,0,134,0,218,0,159,0,186,0,54,0,0,0,99,0,54,0,0,0,43,0,81,0,185,0,48,0,167,0,0,0,52,0,251,0,234,0);
signal scenario_full  : scenario_type := (0,0,33,31,222,31,63,31,197,31,169,31,169,31,236,31,195,31,101,31,13,31,13,30,250,31,250,30,76,31,36,31,3,31,3,30,3,29,179,31,233,31,233,30,9,31,9,30,207,31,75,31,75,30,143,31,11,31,111,31,11,31,152,31,16,31,48,31,48,30,48,29,110,31,174,31,174,30,46,31,46,30,159,31,159,30,164,31,142,31,176,31,176,30,193,31,86,31,89,31,113,31,130,31,238,31,143,31,171,31,60,31,60,30,144,31,158,31,229,31,252,31,14,31,190,31,29,31,72,31,72,30,72,29,192,31,188,31,213,31,234,31,159,31,121,31,166,31,253,31,201,31,105,31,49,31,176,31,124,31,105,31,160,31,201,31,48,31,142,31,142,30,235,31,34,31,124,31,215,31,165,31,163,31,210,31,201,31,232,31,232,30,244,31,244,30,244,29,180,31,238,31,245,31,245,30,245,29,238,31,238,30,238,29,238,28,220,31,12,31,12,30,12,29,12,28,23,31,116,31,8,31,102,31,244,31,157,31,185,31,2,31,242,31,229,31,165,31,165,30,138,31,62,31,16,31,181,31,150,31,150,30,68,31,193,31,34,31,212,31,255,31,179,31,248,31,65,31,185,31,243,31,104,31,65,31,65,30,85,31,205,31,222,31,193,31,48,31,171,31,171,30,171,29,111,31,120,31,27,31,141,31,117,31,252,31,19,31,19,30,216,31,216,30,216,29,208,31,139,31,109,31,15,31,143,31,200,31,137,31,137,30,27,31,71,31,29,31,6,31,66,31,243,31,251,31,204,31,208,31,208,30,147,31,133,31,140,31,125,31,107,31,107,30,107,29,18,31,61,31,61,30,243,31,100,31,100,30,243,31,164,31,164,30,213,31,154,31,113,31,113,30,241,31,241,30,65,31,65,30,150,31,5,31,135,31,135,30,139,31,239,31,239,31,172,31,172,30,36,31,104,31,82,31,212,31,212,30,212,29,142,31,88,31,39,31,6,31,187,31,78,31,252,31,38,31,16,31,37,31,21,31,35,31,248,31,73,31,187,31,9,31,9,30,241,31,196,31,200,31,200,30,200,29,2,31,112,31,52,31,52,30,98,31,98,30,98,29,98,28,98,27,98,26,98,25,2,31,158,31,43,31,114,31,247,31,75,31,75,30,75,29,233,31,202,31,12,31,12,30,251,31,81,31,81,30,81,29,81,28,81,27,240,31,169,31,169,30,153,31,153,30,217,31,114,31,248,31,183,31,166,31,185,31,1,31,1,30,188,31,29,31,69,31,201,31,67,31,109,31,109,30,23,31,51,31,207,31,42,31,91,31,79,31,133,31,133,30,133,29,80,31,219,31,22,31,132,31,132,30,90,31,90,30,83,31,83,30,83,29,39,31,67,31,99,31,151,31,24,31,132,31,124,31,2,31,98,31,8,31,84,31,113,31,147,31,1,31,240,31,54,31,54,30,175,31,175,30,237,31,237,30,31,31,102,31,163,31,74,31,190,31,218,31,151,31,12,31,12,30,138,31,80,31,55,31,47,31,86,31,86,30,59,31,59,30,24,31,219,31,219,30,44,31,170,31,161,31,73,31,73,30,195,31,195,30,30,31,133,31,112,31,117,31,117,30,94,31,207,31,216,31,42,31,228,31,228,30,63,31,254,31,181,31,60,31,80,31,79,31,5,31,226,31,223,31,223,30,223,29,239,31,103,31,103,30,193,31,220,31,93,31,93,30,39,31,214,31,241,31,109,31,109,30,241,31,137,31,105,31,221,31,64,31,188,31,74,31,51,31,127,31,217,31,71,31,49,31,15,31,62,31,35,31,169,31,174,31,174,30,182,31,3,31,184,31,23,31,23,30,216,31,179,31,255,31,255,30,83,31,176,31,63,31,232,31,64,31,130,31,113,31,236,31,2,31,61,31,34,31,34,30,171,31,134,31,1,31,250,31,20,31,74,31,74,30,147,31,182,31,182,30,182,29,170,31,121,31,121,30,121,29,159,31,159,30,203,31,172,31,111,31,111,30,64,31,172,31,248,31,244,31,9,31,233,31,147,31,128,31,128,30,66,31,66,30,210,31,107,31,44,31,44,30,192,31,155,31,155,30,88,31,88,30,45,31,223,31,26,31,67,31,67,30,164,31,22,31,235,31,235,30,57,31,197,31,214,31,214,30,162,31,22,31,34,31,34,30,151,31,64,31,75,31,144,31,144,30,36,31,25,31,90,31,131,31,210,31,160,31,160,30,55,31,187,31,117,31,56,31,234,31,70,31,165,31,86,31,86,30,17,31,194,31,134,31,218,31,159,31,186,31,54,31,54,30,99,31,54,31,54,30,43,31,81,31,185,31,48,31,167,31,167,30,52,31,251,31,234,31);

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
