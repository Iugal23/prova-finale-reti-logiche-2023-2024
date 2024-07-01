-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_538 is
end project_tb_538;

architecture project_tb_arch_538 of project_tb_538 is
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

constant SCENARIO_LENGTH : integer := 587;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (233,0,6,0,76,0,0,0,53,0,169,0,90,0,77,0,230,0,140,0,219,0,114,0,0,0,0,0,107,0,153,0,183,0,97,0,29,0,45,0,136,0,180,0,0,0,0,0,0,0,0,0,69,0,39,0,76,0,0,0,192,0,194,0,128,0,170,0,147,0,188,0,0,0,94,0,0,0,192,0,153,0,239,0,239,0,20,0,115,0,118,0,104,0,125,0,116,0,0,0,235,0,19,0,50,0,0,0,0,0,133,0,213,0,3,0,154,0,33,0,130,0,0,0,191,0,151,0,87,0,147,0,26,0,243,0,88,0,0,0,193,0,126,0,166,0,2,0,73,0,167,0,247,0,2,0,109,0,139,0,206,0,69,0,90,0,251,0,70,0,244,0,145,0,88,0,121,0,14,0,146,0,255,0,0,0,23,0,234,0,97,0,0,0,83,0,0,0,0,0,26,0,61,0,182,0,9,0,12,0,80,0,95,0,0,0,88,0,209,0,207,0,0,0,233,0,223,0,145,0,135,0,212,0,74,0,0,0,249,0,167,0,88,0,140,0,116,0,198,0,95,0,18,0,22,0,222,0,42,0,214,0,47,0,179,0,0,0,111,0,211,0,0,0,0,0,30,0,86,0,235,0,0,0,151,0,46,0,22,0,134,0,203,0,148,0,121,0,231,0,194,0,210,0,10,0,124,0,10,0,93,0,52,0,75,0,149,0,2,0,177,0,158,0,116,0,100,0,0,0,77,0,195,0,252,0,0,0,163,0,133,0,42,0,0,0,0,0,0,0,0,0,114,0,146,0,0,0,99,0,145,0,142,0,84,0,3,0,0,0,0,0,114,0,85,0,225,0,23,0,77,0,167,0,204,0,0,0,227,0,110,0,224,0,142,0,109,0,0,0,73,0,66,0,107,0,189,0,127,0,0,0,102,0,9,0,0,0,0,0,0,0,122,0,173,0,28,0,0,0,106,0,203,0,121,0,137,0,5,0,145,0,190,0,0,0,146,0,126,0,65,0,140,0,165,0,0,0,148,0,133,0,0,0,234,0,161,0,119,0,103,0,177,0,26,0,241,0,145,0,242,0,0,0,215,0,7,0,137,0,178,0,94,0,0,0,74,0,20,0,150,0,231,0,253,0,126,0,106,0,197,0,162,0,124,0,222,0,88,0,1,0,200,0,87,0,121,0,0,0,7,0,139,0,12,0,133,0,13,0,29,0,139,0,101,0,159,0,0,0,164,0,122,0,0,0,152,0,215,0,153,0,0,0,168,0,0,0,179,0,186,0,45,0,60,0,171,0,63,0,205,0,209,0,186,0,116,0,180,0,226,0,246,0,5,0,0,0,0,0,88,0,133,0,30,0,49,0,206,0,12,0,0,0,0,0,161,0,76,0,142,0,214,0,193,0,249,0,88,0,126,0,164,0,218,0,210,0,221,0,48,0,201,0,149,0,0,0,0,0,173,0,147,0,181,0,151,0,0,0,3,0,0,0,0,0,0,0,249,0,126,0,0,0,52,0,18,0,224,0,141,0,48,0,109,0,199,0,183,0,228,0,93,0,147,0,160,0,128,0,115,0,0,0,105,0,196,0,180,0,36,0,56,0,0,0,253,0,0,0,55,0,0,0,222,0,49,0,115,0,74,0,0,0,0,0,254,0,0,0,132,0,123,0,124,0,135,0,65,0,146,0,75,0,168,0,28,0,0,0,33,0,228,0,243,0,0,0,0,0,148,0,0,0,236,0,30,0,119,0,224,0,91,0,128,0,0,0,0,0,168,0,0,0,155,0,3,0,0,0,233,0,219,0,234,0,46,0,209,0,109,0,40,0,66,0,252,0,252,0,189,0,90,0,0,0,131,0,122,0,108,0,85,0,224,0,0,0,103,0,212,0,0,0,157,0,72,0,0,0,139,0,0,0,93,0,30,0,0,0,0,0,14,0,106,0,95,0,0,0,184,0,227,0,0,0,46,0,78,0,224,0,0,0,129,0,200,0,0,0,214,0,160,0,206,0,48,0,0,0,65,0,0,0,58,0,99,0,189,0,226,0,32,0,103,0,41,0,188,0,127,0,64,0,245,0,137,0,3,0,166,0,84,0,230,0,168,0,155,0,0,0,9,0,20,0,192,0,0,0,222,0,204,0,153,0,81,0,43,0,0,0,251,0,70,0,116,0,0,0,106,0,247,0,44,0,0,0,103,0,111,0,3,0,252,0,101,0,138,0,179,0,0,0,129,0,64,0,131,0,0,0,188,0,180,0,235,0,20,0,160,0,104,0,200,0,27,0,66,0,240,0,212,0,229,0,249,0,156,0,117,0,207,0,0,0,33,0,0,0,204,0,241,0,24,0,0,0,132,0,213,0,0,0,0,0,0,0,184,0,50,0,237,0,196,0,206,0,73,0,232,0,0,0,74,0,0,0,226,0,158,0,182,0,65,0,171,0,0,0,9,0,209,0,42,0,3,0,191,0,0,0,21,0,0,0,39,0,7,0,105,0,241,0,211,0,131,0,102,0,0,0,130,0,0,0,222,0,71,0,92,0,199,0,123,0,229,0,9,0,234,0,10,0,163,0,0,0,60,0,0,0,3,0,34,0,0,0,91,0,78,0,10,0,0,0,0,0,59,0,186,0,196,0);
signal scenario_full  : scenario_type := (233,31,6,31,76,31,76,30,53,31,169,31,90,31,77,31,230,31,140,31,219,31,114,31,114,30,114,29,107,31,153,31,183,31,97,31,29,31,45,31,136,31,180,31,180,30,180,29,180,28,180,27,69,31,39,31,76,31,76,30,192,31,194,31,128,31,170,31,147,31,188,31,188,30,94,31,94,30,192,31,153,31,239,31,239,31,20,31,115,31,118,31,104,31,125,31,116,31,116,30,235,31,19,31,50,31,50,30,50,29,133,31,213,31,3,31,154,31,33,31,130,31,130,30,191,31,151,31,87,31,147,31,26,31,243,31,88,31,88,30,193,31,126,31,166,31,2,31,73,31,167,31,247,31,2,31,109,31,139,31,206,31,69,31,90,31,251,31,70,31,244,31,145,31,88,31,121,31,14,31,146,31,255,31,255,30,23,31,234,31,97,31,97,30,83,31,83,30,83,29,26,31,61,31,182,31,9,31,12,31,80,31,95,31,95,30,88,31,209,31,207,31,207,30,233,31,223,31,145,31,135,31,212,31,74,31,74,30,249,31,167,31,88,31,140,31,116,31,198,31,95,31,18,31,22,31,222,31,42,31,214,31,47,31,179,31,179,30,111,31,211,31,211,30,211,29,30,31,86,31,235,31,235,30,151,31,46,31,22,31,134,31,203,31,148,31,121,31,231,31,194,31,210,31,10,31,124,31,10,31,93,31,52,31,75,31,149,31,2,31,177,31,158,31,116,31,100,31,100,30,77,31,195,31,252,31,252,30,163,31,133,31,42,31,42,30,42,29,42,28,42,27,114,31,146,31,146,30,99,31,145,31,142,31,84,31,3,31,3,30,3,29,114,31,85,31,225,31,23,31,77,31,167,31,204,31,204,30,227,31,110,31,224,31,142,31,109,31,109,30,73,31,66,31,107,31,189,31,127,31,127,30,102,31,9,31,9,30,9,29,9,28,122,31,173,31,28,31,28,30,106,31,203,31,121,31,137,31,5,31,145,31,190,31,190,30,146,31,126,31,65,31,140,31,165,31,165,30,148,31,133,31,133,30,234,31,161,31,119,31,103,31,177,31,26,31,241,31,145,31,242,31,242,30,215,31,7,31,137,31,178,31,94,31,94,30,74,31,20,31,150,31,231,31,253,31,126,31,106,31,197,31,162,31,124,31,222,31,88,31,1,31,200,31,87,31,121,31,121,30,7,31,139,31,12,31,133,31,13,31,29,31,139,31,101,31,159,31,159,30,164,31,122,31,122,30,152,31,215,31,153,31,153,30,168,31,168,30,179,31,186,31,45,31,60,31,171,31,63,31,205,31,209,31,186,31,116,31,180,31,226,31,246,31,5,31,5,30,5,29,88,31,133,31,30,31,49,31,206,31,12,31,12,30,12,29,161,31,76,31,142,31,214,31,193,31,249,31,88,31,126,31,164,31,218,31,210,31,221,31,48,31,201,31,149,31,149,30,149,29,173,31,147,31,181,31,151,31,151,30,3,31,3,30,3,29,3,28,249,31,126,31,126,30,52,31,18,31,224,31,141,31,48,31,109,31,199,31,183,31,228,31,93,31,147,31,160,31,128,31,115,31,115,30,105,31,196,31,180,31,36,31,56,31,56,30,253,31,253,30,55,31,55,30,222,31,49,31,115,31,74,31,74,30,74,29,254,31,254,30,132,31,123,31,124,31,135,31,65,31,146,31,75,31,168,31,28,31,28,30,33,31,228,31,243,31,243,30,243,29,148,31,148,30,236,31,30,31,119,31,224,31,91,31,128,31,128,30,128,29,168,31,168,30,155,31,3,31,3,30,233,31,219,31,234,31,46,31,209,31,109,31,40,31,66,31,252,31,252,31,189,31,90,31,90,30,131,31,122,31,108,31,85,31,224,31,224,30,103,31,212,31,212,30,157,31,72,31,72,30,139,31,139,30,93,31,30,31,30,30,30,29,14,31,106,31,95,31,95,30,184,31,227,31,227,30,46,31,78,31,224,31,224,30,129,31,200,31,200,30,214,31,160,31,206,31,48,31,48,30,65,31,65,30,58,31,99,31,189,31,226,31,32,31,103,31,41,31,188,31,127,31,64,31,245,31,137,31,3,31,166,31,84,31,230,31,168,31,155,31,155,30,9,31,20,31,192,31,192,30,222,31,204,31,153,31,81,31,43,31,43,30,251,31,70,31,116,31,116,30,106,31,247,31,44,31,44,30,103,31,111,31,3,31,252,31,101,31,138,31,179,31,179,30,129,31,64,31,131,31,131,30,188,31,180,31,235,31,20,31,160,31,104,31,200,31,27,31,66,31,240,31,212,31,229,31,249,31,156,31,117,31,207,31,207,30,33,31,33,30,204,31,241,31,24,31,24,30,132,31,213,31,213,30,213,29,213,28,184,31,50,31,237,31,196,31,206,31,73,31,232,31,232,30,74,31,74,30,226,31,158,31,182,31,65,31,171,31,171,30,9,31,209,31,42,31,3,31,191,31,191,30,21,31,21,30,39,31,7,31,105,31,241,31,211,31,131,31,102,31,102,30,130,31,130,30,222,31,71,31,92,31,199,31,123,31,229,31,9,31,234,31,10,31,163,31,163,30,60,31,60,30,3,31,34,31,34,30,91,31,78,31,10,31,10,30,10,29,59,31,186,31,196,31);

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
