-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_423 is
end project_tb_423;

architecture project_tb_arch_423 of project_tb_423 is
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

constant SCENARIO_LENGTH : integer := 700;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,210,0,236,0,48,0,0,0,84,0,249,0,0,0,244,0,202,0,41,0,216,0,194,0,182,0,42,0,241,0,0,0,97,0,145,0,43,0,133,0,56,0,194,0,0,0,91,0,154,0,88,0,249,0,161,0,201,0,184,0,65,0,8,0,101,0,70,0,194,0,28,0,132,0,204,0,0,0,78,0,145,0,82,0,230,0,205,0,105,0,50,0,205,0,0,0,0,0,247,0,0,0,0,0,159,0,202,0,165,0,0,0,0,0,48,0,228,0,106,0,144,0,158,0,41,0,78,0,6,0,219,0,218,0,235,0,159,0,1,0,103,0,0,0,0,0,0,0,128,0,187,0,80,0,226,0,224,0,227,0,184,0,4,0,224,0,66,0,72,0,2,0,52,0,75,0,1,0,5,0,132,0,180,0,236,0,0,0,195,0,70,0,43,0,156,0,210,0,0,0,0,0,130,0,59,0,101,0,153,0,35,0,79,0,54,0,122,0,0,0,0,0,119,0,162,0,37,0,163,0,247,0,213,0,0,0,0,0,0,0,124,0,107,0,5,0,47,0,0,0,123,0,0,0,128,0,75,0,175,0,102,0,0,0,252,0,10,0,7,0,117,0,0,0,0,0,216,0,0,0,46,0,55,0,110,0,64,0,0,0,51,0,44,0,20,0,147,0,224,0,82,0,219,0,177,0,114,0,216,0,0,0,180,0,165,0,205,0,204,0,244,0,25,0,237,0,243,0,39,0,0,0,59,0,26,0,51,0,237,0,7,0,55,0,244,0,0,0,145,0,36,0,0,0,152,0,106,0,248,0,217,0,123,0,225,0,113,0,36,0,100,0,0,0,244,0,158,0,57,0,148,0,227,0,0,0,237,0,58,0,174,0,193,0,252,0,213,0,18,0,84,0,156,0,0,0,60,0,119,0,111,0,0,0,15,0,64,0,111,0,164,0,0,0,205,0,0,0,8,0,68,0,216,0,81,0,0,0,246,0,0,0,84,0,0,0,181,0,0,0,238,0,242,0,48,0,211,0,0,0,137,0,92,0,226,0,129,0,19,0,0,0,240,0,255,0,84,0,118,0,126,0,12,0,0,0,25,0,59,0,100,0,0,0,40,0,181,0,237,0,191,0,213,0,117,0,122,0,213,0,66,0,111,0,253,0,190,0,67,0,240,0,0,0,61,0,0,0,225,0,21,0,49,0,88,0,185,0,131,0,40,0,218,0,47,0,136,0,226,0,223,0,0,0,168,0,204,0,239,0,48,0,0,0,9,0,207,0,64,0,0,0,236,0,154,0,227,0,0,0,215,0,249,0,162,0,166,0,48,0,51,0,2,0,104,0,139,0,163,0,158,0,81,0,0,0,195,0,88,0,131,0,250,0,236,0,217,0,30,0,3,0,65,0,8,0,48,0,17,0,124,0,184,0,49,0,116,0,0,0,139,0,50,0,47,0,182,0,91,0,54,0,56,0,63,0,0,0,36,0,6,0,173,0,0,0,0,0,0,0,218,0,0,0,121,0,12,0,41,0,69,0,12,0,105,0,247,0,86,0,185,0,94,0,48,0,17,0,61,0,0,0,73,0,133,0,22,0,0,0,0,0,0,0,244,0,0,0,52,0,60,0,0,0,144,0,36,0,30,0,2,0,203,0,245,0,63,0,187,0,28,0,117,0,128,0,243,0,0,0,68,0,29,0,102,0,26,0,206,0,0,0,34,0,95,0,9,0,215,0,0,0,49,0,0,0,0,0,104,0,170,0,81,0,0,0,0,0,177,0,136,0,222,0,82,0,0,0,250,0,159,0,226,0,0,0,153,0,0,0,114,0,97,0,0,0,7,0,0,0,0,0,54,0,144,0,173,0,0,0,127,0,189,0,116,0,30,0,163,0,0,0,110,0,142,0,149,0,254,0,132,0,235,0,48,0,0,0,0,0,122,0,132,0,137,0,117,0,13,0,166,0,0,0,49,0,71,0,54,0,30,0,228,0,99,0,0,0,6,0,43,0,174,0,139,0,5,0,211,0,108,0,0,0,153,0,114,0,0,0,0,0,0,0,52,0,160,0,131,0,23,0,249,0,0,0,127,0,247,0,199,0,0,0,0,0,45,0,36,0,204,0,50,0,142,0,40,0,163,0,134,0,62,0,225,0,100,0,244,0,122,0,116,0,90,0,113,0,117,0,34,0,32,0,0,0,177,0,248,0,0,0,225,0,248,0,231,0,225,0,250,0,234,0,12,0,91,0,158,0,217,0,171,0,207,0,44,0,175,0,0,0,254,0,71,0,125,0,55,0,248,0,0,0,197,0,110,0,38,0,85,0,111,0,245,0,237,0,118,0,255,0,204,0,231,0,90,0,141,0,0,0,50,0,85,0,0,0,70,0,146,0,16,0,18,0,0,0,0,0,247,0,37,0,251,0,98,0,0,0,92,0,21,0,56,0,93,0,0,0,0,0,141,0,0,0,137,0,141,0,41,0,48,0,233,0,233,0,0,0,0,0,139,0,59,0,131,0,11,0,254,0,117,0,0,0,204,0,145,0,100,0,189,0,235,0,2,0,226,0,0,0,0,0,37,0,210,0,178,0,189,0,246,0,152,0,161,0,93,0,225,0,137,0,97,0,90,0,0,0,241,0,0,0,211,0,48,0,194,0,236,0,23,0,0,0,194,0,223,0,137,0,0,0,142,0,176,0,123,0,0,0,233,0,233,0,28,0,0,0,167,0,87,0,135,0,59,0,0,0,0,0,96,0,15,0,29,0,141,0,102,0,0,0,0,0,158,0,192,0,0,0,203,0,212,0,96,0,155,0,0,0,191,0,74,0,65,0,214,0,243,0,0,0,143,0,177,0,4,0,0,0,168,0,0,0,96,0,143,0,202,0,252,0,0,0,0,0,121,0,0,0,149,0,40,0,173,0,152,0,177,0,40,0,57,0,144,0,68,0,238,0,48,0,180,0,0,0,111,0,26,0,218,0,178,0,206,0,0,0,221,0,0,0,0,0,139,0,93,0,224,0,164,0,38,0,32,0,0,0,38,0,42,0,251,0,49,0,78,0,69,0,169,0,187,0,81,0,163,0,148,0,37,0,19,0,0,0,98,0,168,0,32,0,0,0,0,0,245,0,0,0,92,0,95,0,0,0);
signal scenario_full  : scenario_type := (0,0,210,31,236,31,48,31,48,30,84,31,249,31,249,30,244,31,202,31,41,31,216,31,194,31,182,31,42,31,241,31,241,30,97,31,145,31,43,31,133,31,56,31,194,31,194,30,91,31,154,31,88,31,249,31,161,31,201,31,184,31,65,31,8,31,101,31,70,31,194,31,28,31,132,31,204,31,204,30,78,31,145,31,82,31,230,31,205,31,105,31,50,31,205,31,205,30,205,29,247,31,247,30,247,29,159,31,202,31,165,31,165,30,165,29,48,31,228,31,106,31,144,31,158,31,41,31,78,31,6,31,219,31,218,31,235,31,159,31,1,31,103,31,103,30,103,29,103,28,128,31,187,31,80,31,226,31,224,31,227,31,184,31,4,31,224,31,66,31,72,31,2,31,52,31,75,31,1,31,5,31,132,31,180,31,236,31,236,30,195,31,70,31,43,31,156,31,210,31,210,30,210,29,130,31,59,31,101,31,153,31,35,31,79,31,54,31,122,31,122,30,122,29,119,31,162,31,37,31,163,31,247,31,213,31,213,30,213,29,213,28,124,31,107,31,5,31,47,31,47,30,123,31,123,30,128,31,75,31,175,31,102,31,102,30,252,31,10,31,7,31,117,31,117,30,117,29,216,31,216,30,46,31,55,31,110,31,64,31,64,30,51,31,44,31,20,31,147,31,224,31,82,31,219,31,177,31,114,31,216,31,216,30,180,31,165,31,205,31,204,31,244,31,25,31,237,31,243,31,39,31,39,30,59,31,26,31,51,31,237,31,7,31,55,31,244,31,244,30,145,31,36,31,36,30,152,31,106,31,248,31,217,31,123,31,225,31,113,31,36,31,100,31,100,30,244,31,158,31,57,31,148,31,227,31,227,30,237,31,58,31,174,31,193,31,252,31,213,31,18,31,84,31,156,31,156,30,60,31,119,31,111,31,111,30,15,31,64,31,111,31,164,31,164,30,205,31,205,30,8,31,68,31,216,31,81,31,81,30,246,31,246,30,84,31,84,30,181,31,181,30,238,31,242,31,48,31,211,31,211,30,137,31,92,31,226,31,129,31,19,31,19,30,240,31,255,31,84,31,118,31,126,31,12,31,12,30,25,31,59,31,100,31,100,30,40,31,181,31,237,31,191,31,213,31,117,31,122,31,213,31,66,31,111,31,253,31,190,31,67,31,240,31,240,30,61,31,61,30,225,31,21,31,49,31,88,31,185,31,131,31,40,31,218,31,47,31,136,31,226,31,223,31,223,30,168,31,204,31,239,31,48,31,48,30,9,31,207,31,64,31,64,30,236,31,154,31,227,31,227,30,215,31,249,31,162,31,166,31,48,31,51,31,2,31,104,31,139,31,163,31,158,31,81,31,81,30,195,31,88,31,131,31,250,31,236,31,217,31,30,31,3,31,65,31,8,31,48,31,17,31,124,31,184,31,49,31,116,31,116,30,139,31,50,31,47,31,182,31,91,31,54,31,56,31,63,31,63,30,36,31,6,31,173,31,173,30,173,29,173,28,218,31,218,30,121,31,12,31,41,31,69,31,12,31,105,31,247,31,86,31,185,31,94,31,48,31,17,31,61,31,61,30,73,31,133,31,22,31,22,30,22,29,22,28,244,31,244,30,52,31,60,31,60,30,144,31,36,31,30,31,2,31,203,31,245,31,63,31,187,31,28,31,117,31,128,31,243,31,243,30,68,31,29,31,102,31,26,31,206,31,206,30,34,31,95,31,9,31,215,31,215,30,49,31,49,30,49,29,104,31,170,31,81,31,81,30,81,29,177,31,136,31,222,31,82,31,82,30,250,31,159,31,226,31,226,30,153,31,153,30,114,31,97,31,97,30,7,31,7,30,7,29,54,31,144,31,173,31,173,30,127,31,189,31,116,31,30,31,163,31,163,30,110,31,142,31,149,31,254,31,132,31,235,31,48,31,48,30,48,29,122,31,132,31,137,31,117,31,13,31,166,31,166,30,49,31,71,31,54,31,30,31,228,31,99,31,99,30,6,31,43,31,174,31,139,31,5,31,211,31,108,31,108,30,153,31,114,31,114,30,114,29,114,28,52,31,160,31,131,31,23,31,249,31,249,30,127,31,247,31,199,31,199,30,199,29,45,31,36,31,204,31,50,31,142,31,40,31,163,31,134,31,62,31,225,31,100,31,244,31,122,31,116,31,90,31,113,31,117,31,34,31,32,31,32,30,177,31,248,31,248,30,225,31,248,31,231,31,225,31,250,31,234,31,12,31,91,31,158,31,217,31,171,31,207,31,44,31,175,31,175,30,254,31,71,31,125,31,55,31,248,31,248,30,197,31,110,31,38,31,85,31,111,31,245,31,237,31,118,31,255,31,204,31,231,31,90,31,141,31,141,30,50,31,85,31,85,30,70,31,146,31,16,31,18,31,18,30,18,29,247,31,37,31,251,31,98,31,98,30,92,31,21,31,56,31,93,31,93,30,93,29,141,31,141,30,137,31,141,31,41,31,48,31,233,31,233,31,233,30,233,29,139,31,59,31,131,31,11,31,254,31,117,31,117,30,204,31,145,31,100,31,189,31,235,31,2,31,226,31,226,30,226,29,37,31,210,31,178,31,189,31,246,31,152,31,161,31,93,31,225,31,137,31,97,31,90,31,90,30,241,31,241,30,211,31,48,31,194,31,236,31,23,31,23,30,194,31,223,31,137,31,137,30,142,31,176,31,123,31,123,30,233,31,233,31,28,31,28,30,167,31,87,31,135,31,59,31,59,30,59,29,96,31,15,31,29,31,141,31,102,31,102,30,102,29,158,31,192,31,192,30,203,31,212,31,96,31,155,31,155,30,191,31,74,31,65,31,214,31,243,31,243,30,143,31,177,31,4,31,4,30,168,31,168,30,96,31,143,31,202,31,252,31,252,30,252,29,121,31,121,30,149,31,40,31,173,31,152,31,177,31,40,31,57,31,144,31,68,31,238,31,48,31,180,31,180,30,111,31,26,31,218,31,178,31,206,31,206,30,221,31,221,30,221,29,139,31,93,31,224,31,164,31,38,31,32,31,32,30,38,31,42,31,251,31,49,31,78,31,69,31,169,31,187,31,81,31,163,31,148,31,37,31,19,31,19,30,98,31,168,31,32,31,32,30,32,29,245,31,245,30,92,31,95,31,95,30);

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
