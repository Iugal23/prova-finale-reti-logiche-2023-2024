-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_525 is
end project_tb_525;

architecture project_tb_arch_525 of project_tb_525 is
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

constant SCENARIO_LENGTH : integer := 740;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,101,0,55,0,217,0,192,0,63,0,146,0,56,0,221,0,0,0,0,0,138,0,88,0,0,0,133,0,0,0,150,0,0,0,0,0,158,0,159,0,47,0,0,0,249,0,234,0,226,0,5,0,86,0,187,0,52,0,208,0,101,0,0,0,217,0,203,0,146,0,0,0,26,0,0,0,113,0,166,0,190,0,167,0,0,0,237,0,166,0,49,0,102,0,48,0,7,0,62,0,14,0,0,0,201,0,227,0,145,0,156,0,0,0,37,0,8,0,116,0,0,0,0,0,5,0,189,0,115,0,164,0,0,0,0,0,39,0,162,0,111,0,0,0,0,0,40,0,105,0,91,0,33,0,115,0,23,0,200,0,79,0,147,0,115,0,188,0,178,0,0,0,0,0,141,0,174,0,45,0,103,0,129,0,151,0,246,0,83,0,181,0,0,0,224,0,167,0,228,0,0,0,213,0,206,0,0,0,0,0,193,0,26,0,24,0,218,0,204,0,90,0,231,0,202,0,0,0,191,0,156,0,103,0,20,0,0,0,135,0,178,0,231,0,51,0,0,0,245,0,0,0,18,0,0,0,0,0,114,0,135,0,35,0,206,0,233,0,0,0,36,0,123,0,213,0,0,0,132,0,172,0,5,0,181,0,112,0,26,0,113,0,186,0,0,0,199,0,154,0,235,0,44,0,26,0,0,0,202,0,171,0,0,0,165,0,234,0,0,0,80,0,113,0,228,0,151,0,0,0,187,0,0,0,166,0,21,0,159,0,0,0,99,0,154,0,0,0,143,0,42,0,174,0,234,0,181,0,0,0,146,0,159,0,40,0,187,0,234,0,44,0,43,0,237,0,218,0,11,0,181,0,0,0,182,0,179,0,125,0,0,0,28,0,22,0,19,0,0,0,109,0,152,0,4,0,91,0,197,0,0,0,173,0,56,0,244,0,170,0,134,0,189,0,82,0,30,0,138,0,69,0,0,0,0,0,161,0,101,0,73,0,152,0,29,0,83,0,93,0,0,0,102,0,87,0,43,0,235,0,177,0,60,0,34,0,114,0,142,0,235,0,0,0,148,0,0,0,16,0,0,0,179,0,177,0,0,0,110,0,147,0,93,0,77,0,0,0,0,0,179,0,38,0,0,0,225,0,253,0,0,0,126,0,110,0,141,0,234,0,36,0,0,0,0,0,137,0,180,0,29,0,0,0,100,0,219,0,59,0,232,0,169,0,180,0,10,0,161,0,145,0,121,0,129,0,0,0,125,0,253,0,186,0,202,0,240,0,45,0,63,0,212,0,164,0,7,0,0,0,0,0,137,0,0,0,32,0,68,0,168,0,151,0,3,0,107,0,0,0,105,0,87,0,40,0,0,0,144,0,0,0,63,0,174,0,6,0,8,0,2,0,126,0,237,0,28,0,229,0,241,0,249,0,63,0,68,0,234,0,134,0,15,0,211,0,15,0,0,0,91,0,0,0,210,0,18,0,126,0,199,0,48,0,188,0,65,0,236,0,155,0,11,0,228,0,0,0,193,0,239,0,4,0,241,0,0,0,228,0,135,0,0,0,164,0,185,0,0,0,0,0,0,0,0,0,85,0,127,0,147,0,101,0,94,0,0,0,249,0,0,0,97,0,101,0,112,0,138,0,115,0,232,0,15,0,0,0,166,0,147,0,68,0,155,0,153,0,0,0,24,0,18,0,209,0,94,0,60,0,200,0,236,0,196,0,17,0,0,0,0,0,56,0,210,0,255,0,26,0,188,0,28,0,58,0,219,0,232,0,237,0,0,0,154,0,87,0,11,0,121,0,125,0,0,0,240,0,176,0,0,0,30,0,0,0,244,0,162,0,68,0,204,0,7,0,0,0,59,0,62,0,41,0,229,0,0,0,254,0,0,0,192,0,0,0,31,0,203,0,135,0,0,0,0,0,79,0,32,0,56,0,215,0,252,0,244,0,254,0,0,0,137,0,174,0,43,0,190,0,130,0,84,0,8,0,114,0,0,0,216,0,1,0,108,0,251,0,0,0,0,0,221,0,223,0,179,0,138,0,154,0,0,0,100,0,0,0,83,0,217,0,143,0,244,0,0,0,53,0,156,0,173,0,183,0,248,0,0,0,0,0,210,0,226,0,0,0,0,0,48,0,54,0,0,0,191,0,252,0,64,0,160,0,40,0,57,0,7,0,8,0,54,0,0,0,7,0,23,0,4,0,123,0,104,0,191,0,0,0,120,0,0,0,234,0,131,0,151,0,209,0,186,0,252,0,131,0,207,0,0,0,101,0,0,0,234,0,108,0,233,0,51,0,14,0,184,0,165,0,172,0,0,0,252,0,197,0,209,0,0,0,245,0,117,0,101,0,106,0,139,0,107,0,115,0,203,0,0,0,238,0,1,0,109,0,245,0,0,0,76,0,123,0,0,0,73,0,183,0,215,0,0,0,42,0,147,0,236,0,211,0,249,0,23,0,216,0,245,0,0,0,5,0,87,0,187,0,0,0,0,0,212,0,142,0,219,0,62,0,190,0,0,0,176,0,166,0,71,0,39,0,42,0,110,0,188,0,36,0,0,0,114,0,133,0,0,0,9,0,8,0,9,0,51,0,56,0,241,0,0,0,0,0,0,0,134,0,42,0,0,0,46,0,0,0,171,0,187,0,129,0,197,0,0,0,169,0,252,0,185,0,123,0,217,0,226,0,23,0,79,0,106,0,6,0,55,0,0,0,32,0,70,0,182,0,0,0,199,0,36,0,52,0,52,0,226,0,142,0,97,0,60,0,33,0,161,0,31,0,116,0,35,0,237,0,0,0,0,0,97,0,157,0,0,0,217,0,0,0,78,0,0,0,210,0,208,0,24,0,200,0,39,0,0,0,0,0,174,0,56,0,127,0,182,0,111,0,0,0,205,0,69,0,163,0,254,0,154,0,9,0,0,0,202,0,99,0,193,0,0,0,0,0,100,0,2,0,153,0,2,0,155,0,130,0,244,0,91,0,97,0,0,0,162,0,165,0,2,0,0,0,26,0,48,0,198,0,86,0,0,0,85,0,195,0,34,0,2,0,100,0,0,0,173,0,145,0,122,0,31,0,151,0,0,0,238,0,178,0,247,0,0,0,99,0,0,0,56,0,60,0,146,0,36,0,240,0,68,0,224,0,182,0,239,0,20,0,36,0,224,0,46,0,161,0,168,0,82,0,196,0,69,0,36,0,107,0,181,0,35,0,0,0,53,0,0,0,23,0,210,0,0,0,4,0,0,0,0,0,76,0,0,0,36,0,240,0,0,0,123,0,81,0,123,0,38,0,84,0,219,0,192,0,206,0);
signal scenario_full  : scenario_type := (0,0,0,0,101,31,55,31,217,31,192,31,63,31,146,31,56,31,221,31,221,30,221,29,138,31,88,31,88,30,133,31,133,30,150,31,150,30,150,29,158,31,159,31,47,31,47,30,249,31,234,31,226,31,5,31,86,31,187,31,52,31,208,31,101,31,101,30,217,31,203,31,146,31,146,30,26,31,26,30,113,31,166,31,190,31,167,31,167,30,237,31,166,31,49,31,102,31,48,31,7,31,62,31,14,31,14,30,201,31,227,31,145,31,156,31,156,30,37,31,8,31,116,31,116,30,116,29,5,31,189,31,115,31,164,31,164,30,164,29,39,31,162,31,111,31,111,30,111,29,40,31,105,31,91,31,33,31,115,31,23,31,200,31,79,31,147,31,115,31,188,31,178,31,178,30,178,29,141,31,174,31,45,31,103,31,129,31,151,31,246,31,83,31,181,31,181,30,224,31,167,31,228,31,228,30,213,31,206,31,206,30,206,29,193,31,26,31,24,31,218,31,204,31,90,31,231,31,202,31,202,30,191,31,156,31,103,31,20,31,20,30,135,31,178,31,231,31,51,31,51,30,245,31,245,30,18,31,18,30,18,29,114,31,135,31,35,31,206,31,233,31,233,30,36,31,123,31,213,31,213,30,132,31,172,31,5,31,181,31,112,31,26,31,113,31,186,31,186,30,199,31,154,31,235,31,44,31,26,31,26,30,202,31,171,31,171,30,165,31,234,31,234,30,80,31,113,31,228,31,151,31,151,30,187,31,187,30,166,31,21,31,159,31,159,30,99,31,154,31,154,30,143,31,42,31,174,31,234,31,181,31,181,30,146,31,159,31,40,31,187,31,234,31,44,31,43,31,237,31,218,31,11,31,181,31,181,30,182,31,179,31,125,31,125,30,28,31,22,31,19,31,19,30,109,31,152,31,4,31,91,31,197,31,197,30,173,31,56,31,244,31,170,31,134,31,189,31,82,31,30,31,138,31,69,31,69,30,69,29,161,31,101,31,73,31,152,31,29,31,83,31,93,31,93,30,102,31,87,31,43,31,235,31,177,31,60,31,34,31,114,31,142,31,235,31,235,30,148,31,148,30,16,31,16,30,179,31,177,31,177,30,110,31,147,31,93,31,77,31,77,30,77,29,179,31,38,31,38,30,225,31,253,31,253,30,126,31,110,31,141,31,234,31,36,31,36,30,36,29,137,31,180,31,29,31,29,30,100,31,219,31,59,31,232,31,169,31,180,31,10,31,161,31,145,31,121,31,129,31,129,30,125,31,253,31,186,31,202,31,240,31,45,31,63,31,212,31,164,31,7,31,7,30,7,29,137,31,137,30,32,31,68,31,168,31,151,31,3,31,107,31,107,30,105,31,87,31,40,31,40,30,144,31,144,30,63,31,174,31,6,31,8,31,2,31,126,31,237,31,28,31,229,31,241,31,249,31,63,31,68,31,234,31,134,31,15,31,211,31,15,31,15,30,91,31,91,30,210,31,18,31,126,31,199,31,48,31,188,31,65,31,236,31,155,31,11,31,228,31,228,30,193,31,239,31,4,31,241,31,241,30,228,31,135,31,135,30,164,31,185,31,185,30,185,29,185,28,185,27,85,31,127,31,147,31,101,31,94,31,94,30,249,31,249,30,97,31,101,31,112,31,138,31,115,31,232,31,15,31,15,30,166,31,147,31,68,31,155,31,153,31,153,30,24,31,18,31,209,31,94,31,60,31,200,31,236,31,196,31,17,31,17,30,17,29,56,31,210,31,255,31,26,31,188,31,28,31,58,31,219,31,232,31,237,31,237,30,154,31,87,31,11,31,121,31,125,31,125,30,240,31,176,31,176,30,30,31,30,30,244,31,162,31,68,31,204,31,7,31,7,30,59,31,62,31,41,31,229,31,229,30,254,31,254,30,192,31,192,30,31,31,203,31,135,31,135,30,135,29,79,31,32,31,56,31,215,31,252,31,244,31,254,31,254,30,137,31,174,31,43,31,190,31,130,31,84,31,8,31,114,31,114,30,216,31,1,31,108,31,251,31,251,30,251,29,221,31,223,31,179,31,138,31,154,31,154,30,100,31,100,30,83,31,217,31,143,31,244,31,244,30,53,31,156,31,173,31,183,31,248,31,248,30,248,29,210,31,226,31,226,30,226,29,48,31,54,31,54,30,191,31,252,31,64,31,160,31,40,31,57,31,7,31,8,31,54,31,54,30,7,31,23,31,4,31,123,31,104,31,191,31,191,30,120,31,120,30,234,31,131,31,151,31,209,31,186,31,252,31,131,31,207,31,207,30,101,31,101,30,234,31,108,31,233,31,51,31,14,31,184,31,165,31,172,31,172,30,252,31,197,31,209,31,209,30,245,31,117,31,101,31,106,31,139,31,107,31,115,31,203,31,203,30,238,31,1,31,109,31,245,31,245,30,76,31,123,31,123,30,73,31,183,31,215,31,215,30,42,31,147,31,236,31,211,31,249,31,23,31,216,31,245,31,245,30,5,31,87,31,187,31,187,30,187,29,212,31,142,31,219,31,62,31,190,31,190,30,176,31,166,31,71,31,39,31,42,31,110,31,188,31,36,31,36,30,114,31,133,31,133,30,9,31,8,31,9,31,51,31,56,31,241,31,241,30,241,29,241,28,134,31,42,31,42,30,46,31,46,30,171,31,187,31,129,31,197,31,197,30,169,31,252,31,185,31,123,31,217,31,226,31,23,31,79,31,106,31,6,31,55,31,55,30,32,31,70,31,182,31,182,30,199,31,36,31,52,31,52,31,226,31,142,31,97,31,60,31,33,31,161,31,31,31,116,31,35,31,237,31,237,30,237,29,97,31,157,31,157,30,217,31,217,30,78,31,78,30,210,31,208,31,24,31,200,31,39,31,39,30,39,29,174,31,56,31,127,31,182,31,111,31,111,30,205,31,69,31,163,31,254,31,154,31,9,31,9,30,202,31,99,31,193,31,193,30,193,29,100,31,2,31,153,31,2,31,155,31,130,31,244,31,91,31,97,31,97,30,162,31,165,31,2,31,2,30,26,31,48,31,198,31,86,31,86,30,85,31,195,31,34,31,2,31,100,31,100,30,173,31,145,31,122,31,31,31,151,31,151,30,238,31,178,31,247,31,247,30,99,31,99,30,56,31,60,31,146,31,36,31,240,31,68,31,224,31,182,31,239,31,20,31,36,31,224,31,46,31,161,31,168,31,82,31,196,31,69,31,36,31,107,31,181,31,35,31,35,30,53,31,53,30,23,31,210,31,210,30,4,31,4,30,4,29,76,31,76,30,36,31,240,31,240,30,123,31,81,31,123,31,38,31,84,31,219,31,192,31,206,31);

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
