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

constant SCENARIO_LENGTH : integer := 565;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (147,0,95,0,0,0,46,0,0,0,0,0,0,0,0,0,64,0,135,0,182,0,87,0,17,0,239,0,144,0,184,0,145,0,208,0,117,0,184,0,159,0,176,0,216,0,186,0,0,0,125,0,116,0,163,0,150,0,72,0,191,0,1,0,70,0,233,0,1,0,180,0,134,0,165,0,223,0,43,0,148,0,0,0,218,0,99,0,0,0,13,0,0,0,231,0,185,0,39,0,134,0,55,0,249,0,153,0,117,0,17,0,194,0,54,0,65,0,32,0,171,0,0,0,227,0,65,0,165,0,192,0,0,0,86,0,18,0,71,0,68,0,225,0,0,0,236,0,224,0,111,0,112,0,94,0,132,0,13,0,44,0,0,0,142,0,226,0,107,0,178,0,102,0,102,0,44,0,0,0,161,0,64,0,0,0,226,0,0,0,39,0,201,0,115,0,55,0,119,0,0,0,247,0,7,0,125,0,0,0,47,0,113,0,133,0,193,0,0,0,0,0,74,0,105,0,0,0,97,0,2,0,0,0,195,0,0,0,95,0,126,0,0,0,186,0,205,0,85,0,190,0,186,0,122,0,223,0,0,0,77,0,96,0,178,0,0,0,89,0,225,0,146,0,104,0,0,0,144,0,37,0,94,0,0,0,146,0,142,0,124,0,0,0,0,0,0,0,0,0,0,0,228,0,0,0,216,0,43,0,47,0,0,0,102,0,71,0,78,0,61,0,0,0,94,0,0,0,140,0,0,0,97,0,0,0,34,0,173,0,0,0,0,0,141,0,0,0,39,0,50,0,103,0,70,0,250,0,75,0,0,0,0,0,0,0,0,0,33,0,0,0,0,0,251,0,0,0,153,0,238,0,22,0,0,0,238,0,251,0,229,0,110,0,213,0,49,0,144,0,0,0,255,0,85,0,0,0,0,0,104,0,0,0,252,0,174,0,161,0,98,0,237,0,182,0,247,0,221,0,64,0,0,0,0,0,0,0,36,0,0,0,65,0,116,0,0,0,0,0,37,0,70,0,3,0,18,0,0,0,140,0,17,0,137,0,0,0,67,0,0,0,109,0,0,0,22,0,0,0,116,0,2,0,217,0,240,0,229,0,0,0,89,0,244,0,1,0,0,0,0,0,123,0,148,0,99,0,0,0,33,0,101,0,23,0,0,0,186,0,171,0,16,0,160,0,80,0,0,0,196,0,136,0,174,0,21,0,86,0,57,0,230,0,0,0,218,0,16,0,0,0,103,0,141,0,177,0,201,0,107,0,73,0,186,0,0,0,246,0,149,0,0,0,100,0,88,0,0,0,0,0,1,0,100,0,33,0,38,0,0,0,213,0,206,0,95,0,0,0,0,0,110,0,106,0,160,0,0,0,0,0,0,0,0,0,205,0,166,0,148,0,132,0,73,0,0,0,38,0,95,0,2,0,87,0,50,0,189,0,194,0,0,0,0,0,67,0,0,0,8,0,0,0,0,0,97,0,68,0,236,0,245,0,180,0,165,0,194,0,154,0,217,0,186,0,0,0,206,0,243,0,0,0,135,0,0,0,33,0,0,0,129,0,76,0,232,0,177,0,146,0,26,0,149,0,207,0,0,0,0,0,164,0,236,0,161,0,82,0,0,0,106,0,0,0,84,0,90,0,71,0,142,0,0,0,227,0,0,0,79,0,212,0,201,0,46,0,183,0,208,0,232,0,207,0,219,0,78,0,93,0,245,0,35,0,0,0,0,0,9,0,24,0,84,0,71,0,214,0,210,0,215,0,31,0,81,0,0,0,102,0,0,0,126,0,44,0,63,0,103,0,0,0,206,0,110,0,103,0,20,0,75,0,49,0,52,0,147,0,0,0,0,0,233,0,194,0,0,0,129,0,45,0,254,0,172,0,107,0,155,0,0,0,103,0,204,0,204,0,219,0,198,0,80,0,0,0,188,0,44,0,176,0,251,0,6,0,60,0,0,0,0,0,0,0,13,0,0,0,0,0,2,0,0,0,173,0,41,0,0,0,33,0,0,0,0,0,254,0,155,0,45,0,116,0,0,0,176,0,195,0,214,0,104,0,110,0,233,0,139,0,18,0,127,0,183,0,73,0,215,0,109,0,174,0,104,0,48,0,0,0,188,0,0,0,54,0,0,0,58,0,122,0,104,0,30,0,174,0,221,0,181,0,0,0,122,0,163,0,176,0,129,0,136,0,175,0,147,0,13,0,251,0,214,0,81,0,0,0,253,0,237,0,84,0,0,0,26,0,41,0,150,0,0,0,188,0,71,0,89,0,228,0,0,0,228,0,107,0,113,0,208,0,75,0,113,0,116,0,161,0,0,0,0,0,140,0,81,0,146,0,114,0,171,0,108,0,224,0,126,0,7,0,72,0,75,0,177,0,61,0,236,0,12,0,186,0,0,0,60,0,253,0,0,0,252,0,245,0,63,0,0,0,32,0,248,0,217,0,8,0,152,0,0,0,62,0,133,0,147,0,201,0,103,0,150,0,160,0,132,0,177,0,115,0,111,0,0,0,45,0,74,0,77,0,0,0,146,0);
signal scenario_full  : scenario_type := (147,31,95,31,95,30,46,31,46,30,46,29,46,28,46,27,64,31,135,31,182,31,87,31,17,31,239,31,144,31,184,31,145,31,208,31,117,31,184,31,159,31,176,31,216,31,186,31,186,30,125,31,116,31,163,31,150,31,72,31,191,31,1,31,70,31,233,31,1,31,180,31,134,31,165,31,223,31,43,31,148,31,148,30,218,31,99,31,99,30,13,31,13,30,231,31,185,31,39,31,134,31,55,31,249,31,153,31,117,31,17,31,194,31,54,31,65,31,32,31,171,31,171,30,227,31,65,31,165,31,192,31,192,30,86,31,18,31,71,31,68,31,225,31,225,30,236,31,224,31,111,31,112,31,94,31,132,31,13,31,44,31,44,30,142,31,226,31,107,31,178,31,102,31,102,31,44,31,44,30,161,31,64,31,64,30,226,31,226,30,39,31,201,31,115,31,55,31,119,31,119,30,247,31,7,31,125,31,125,30,47,31,113,31,133,31,193,31,193,30,193,29,74,31,105,31,105,30,97,31,2,31,2,30,195,31,195,30,95,31,126,31,126,30,186,31,205,31,85,31,190,31,186,31,122,31,223,31,223,30,77,31,96,31,178,31,178,30,89,31,225,31,146,31,104,31,104,30,144,31,37,31,94,31,94,30,146,31,142,31,124,31,124,30,124,29,124,28,124,27,124,26,228,31,228,30,216,31,43,31,47,31,47,30,102,31,71,31,78,31,61,31,61,30,94,31,94,30,140,31,140,30,97,31,97,30,34,31,173,31,173,30,173,29,141,31,141,30,39,31,50,31,103,31,70,31,250,31,75,31,75,30,75,29,75,28,75,27,33,31,33,30,33,29,251,31,251,30,153,31,238,31,22,31,22,30,238,31,251,31,229,31,110,31,213,31,49,31,144,31,144,30,255,31,85,31,85,30,85,29,104,31,104,30,252,31,174,31,161,31,98,31,237,31,182,31,247,31,221,31,64,31,64,30,64,29,64,28,36,31,36,30,65,31,116,31,116,30,116,29,37,31,70,31,3,31,18,31,18,30,140,31,17,31,137,31,137,30,67,31,67,30,109,31,109,30,22,31,22,30,116,31,2,31,217,31,240,31,229,31,229,30,89,31,244,31,1,31,1,30,1,29,123,31,148,31,99,31,99,30,33,31,101,31,23,31,23,30,186,31,171,31,16,31,160,31,80,31,80,30,196,31,136,31,174,31,21,31,86,31,57,31,230,31,230,30,218,31,16,31,16,30,103,31,141,31,177,31,201,31,107,31,73,31,186,31,186,30,246,31,149,31,149,30,100,31,88,31,88,30,88,29,1,31,100,31,33,31,38,31,38,30,213,31,206,31,95,31,95,30,95,29,110,31,106,31,160,31,160,30,160,29,160,28,160,27,205,31,166,31,148,31,132,31,73,31,73,30,38,31,95,31,2,31,87,31,50,31,189,31,194,31,194,30,194,29,67,31,67,30,8,31,8,30,8,29,97,31,68,31,236,31,245,31,180,31,165,31,194,31,154,31,217,31,186,31,186,30,206,31,243,31,243,30,135,31,135,30,33,31,33,30,129,31,76,31,232,31,177,31,146,31,26,31,149,31,207,31,207,30,207,29,164,31,236,31,161,31,82,31,82,30,106,31,106,30,84,31,90,31,71,31,142,31,142,30,227,31,227,30,79,31,212,31,201,31,46,31,183,31,208,31,232,31,207,31,219,31,78,31,93,31,245,31,35,31,35,30,35,29,9,31,24,31,84,31,71,31,214,31,210,31,215,31,31,31,81,31,81,30,102,31,102,30,126,31,44,31,63,31,103,31,103,30,206,31,110,31,103,31,20,31,75,31,49,31,52,31,147,31,147,30,147,29,233,31,194,31,194,30,129,31,45,31,254,31,172,31,107,31,155,31,155,30,103,31,204,31,204,31,219,31,198,31,80,31,80,30,188,31,44,31,176,31,251,31,6,31,60,31,60,30,60,29,60,28,13,31,13,30,13,29,2,31,2,30,173,31,41,31,41,30,33,31,33,30,33,29,254,31,155,31,45,31,116,31,116,30,176,31,195,31,214,31,104,31,110,31,233,31,139,31,18,31,127,31,183,31,73,31,215,31,109,31,174,31,104,31,48,31,48,30,188,31,188,30,54,31,54,30,58,31,122,31,104,31,30,31,174,31,221,31,181,31,181,30,122,31,163,31,176,31,129,31,136,31,175,31,147,31,13,31,251,31,214,31,81,31,81,30,253,31,237,31,84,31,84,30,26,31,41,31,150,31,150,30,188,31,71,31,89,31,228,31,228,30,228,31,107,31,113,31,208,31,75,31,113,31,116,31,161,31,161,30,161,29,140,31,81,31,146,31,114,31,171,31,108,31,224,31,126,31,7,31,72,31,75,31,177,31,61,31,236,31,12,31,186,31,186,30,60,31,253,31,253,30,252,31,245,31,63,31,63,30,32,31,248,31,217,31,8,31,152,31,152,30,62,31,133,31,147,31,201,31,103,31,150,31,160,31,132,31,177,31,115,31,111,31,111,30,45,31,74,31,77,31,77,30,146,31);

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
