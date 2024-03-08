-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_428 is
end project_tb_428;

architecture project_tb_arch_428 of project_tb_428 is
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

constant SCENARIO_LENGTH : integer := 533;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (156,0,152,0,0,0,78,0,50,0,0,0,105,0,151,0,183,0,74,0,0,0,190,0,87,0,173,0,243,0,0,0,244,0,139,0,194,0,163,0,66,0,0,0,0,0,0,0,210,0,0,0,1,0,34,0,64,0,187,0,0,0,103,0,0,0,14,0,198,0,0,0,230,0,70,0,220,0,114,0,137,0,127,0,69,0,144,0,0,0,23,0,0,0,32,0,0,0,199,0,0,0,0,0,211,0,186,0,39,0,214,0,134,0,244,0,95,0,18,0,247,0,26,0,68,0,64,0,114,0,145,0,91,0,12,0,193,0,196,0,71,0,0,0,233,0,199,0,0,0,66,0,84,0,86,0,83,0,11,0,0,0,11,0,22,0,249,0,211,0,0,0,235,0,84,0,186,0,0,0,165,0,148,0,97,0,3,0,61,0,235,0,249,0,104,0,138,0,66,0,247,0,131,0,164,0,12,0,0,0,195,0,246,0,101,0,0,0,0,0,228,0,134,0,0,0,227,0,137,0,0,0,74,0,67,0,139,0,111,0,0,0,30,0,152,0,0,0,218,0,2,0,174,0,14,0,179,0,224,0,16,0,109,0,158,0,104,0,0,0,54,0,1,0,222,0,144,0,95,0,92,0,219,0,0,0,46,0,124,0,0,0,116,0,0,0,131,0,121,0,0,0,200,0,0,0,0,0,96,0,86,0,0,0,21,0,93,0,150,0,83,0,212,0,0,0,57,0,182,0,237,0,0,0,167,0,0,0,0,0,0,0,243,0,231,0,46,0,33,0,1,0,44,0,12,0,0,0,23,0,96,0,181,0,238,0,80,0,56,0,104,0,0,0,241,0,55,0,0,0,48,0,192,0,207,0,22,0,71,0,0,0,118,0,150,0,154,0,0,0,207,0,219,0,84,0,189,0,231,0,53,0,200,0,0,0,0,0,87,0,6,0,200,0,26,0,0,0,0,0,64,0,100,0,217,0,167,0,109,0,205,0,115,0,235,0,113,0,29,0,0,0,37,0,57,0,0,0,133,0,104,0,164,0,158,0,152,0,240,0,0,0,29,0,79,0,72,0,94,0,155,0,0,0,0,0,28,0,93,0,170,0,243,0,38,0,168,0,144,0,107,0,249,0,64,0,210,0,58,0,26,0,4,0,131,0,44,0,244,0,158,0,246,0,252,0,154,0,118,0,252,0,202,0,121,0,115,0,75,0,201,0,234,0,35,0,190,0,70,0,0,0,199,0,214,0,141,0,42,0,230,0,72,0,107,0,246,0,67,0,105,0,93,0,0,0,0,0,202,0,191,0,229,0,94,0,99,0,7,0,102,0,219,0,210,0,127,0,214,0,115,0,36,0,0,0,255,0,0,0,244,0,48,0,0,0,0,0,199,0,159,0,163,0,78,0,27,0,0,0,141,0,197,0,80,0,0,0,0,0,235,0,253,0,218,0,235,0,204,0,184,0,0,0,141,0,0,0,152,0,207,0,94,0,102,0,34,0,120,0,0,0,73,0,180,0,0,0,75,0,71,0,148,0,206,0,111,0,88,0,0,0,160,0,114,0,185,0,181,0,4,0,0,0,210,0,59,0,90,0,0,0,9,0,12,0,213,0,151,0,198,0,184,0,31,0,153,0,50,0,0,0,0,0,74,0,29,0,250,0,198,0,128,0,53,0,93,0,247,0,0,0,0,0,0,0,236,0,115,0,116,0,115,0,132,0,202,0,0,0,0,0,203,0,39,0,0,0,203,0,189,0,117,0,0,0,13,0,225,0,63,0,102,0,191,0,242,0,182,0,209,0,0,0,9,0,253,0,77,0,18,0,91,0,0,0,237,0,44,0,0,0,0,0,226,0,2,0,0,0,0,0,20,0,0,0,234,0,0,0,194,0,181,0,0,0,190,0,226,0,221,0,179,0,169,0,12,0,52,0,148,0,186,0,218,0,0,0,119,0,106,0,248,0,211,0,0,0,239,0,0,0,0,0,3,0,42,0,215,0,174,0,168,0,171,0,63,0,0,0,0,0,236,0,180,0,237,0,135,0,12,0,0,0,0,0,13,0,32,0,158,0,51,0,94,0,0,0,73,0,37,0,0,0,199,0,68,0,108,0,207,0,37,0,244,0,142,0,38,0,16,0,134,0,87,0,0,0,37,0,156,0,124,0,143,0,164,0,29,0,113,0,3,0,138,0,54,0,91,0,171,0,141,0,71,0,0,0,245,0,211,0,230,0,10,0,232,0,142,0,5,0,253,0,204,0,211,0,120,0,111,0,233,0,0,0,0,0,221,0,192,0,235,0,154,0,237,0,0,0,31,0,0,0,226,0,106,0,56,0,0,0,133,0,255,0,112,0,46,0,11,0,0,0,164,0,38,0,65,0,219,0,227,0,161,0);
signal scenario_full  : scenario_type := (156,31,152,31,152,30,78,31,50,31,50,30,105,31,151,31,183,31,74,31,74,30,190,31,87,31,173,31,243,31,243,30,244,31,139,31,194,31,163,31,66,31,66,30,66,29,66,28,210,31,210,30,1,31,34,31,64,31,187,31,187,30,103,31,103,30,14,31,198,31,198,30,230,31,70,31,220,31,114,31,137,31,127,31,69,31,144,31,144,30,23,31,23,30,32,31,32,30,199,31,199,30,199,29,211,31,186,31,39,31,214,31,134,31,244,31,95,31,18,31,247,31,26,31,68,31,64,31,114,31,145,31,91,31,12,31,193,31,196,31,71,31,71,30,233,31,199,31,199,30,66,31,84,31,86,31,83,31,11,31,11,30,11,31,22,31,249,31,211,31,211,30,235,31,84,31,186,31,186,30,165,31,148,31,97,31,3,31,61,31,235,31,249,31,104,31,138,31,66,31,247,31,131,31,164,31,12,31,12,30,195,31,246,31,101,31,101,30,101,29,228,31,134,31,134,30,227,31,137,31,137,30,74,31,67,31,139,31,111,31,111,30,30,31,152,31,152,30,218,31,2,31,174,31,14,31,179,31,224,31,16,31,109,31,158,31,104,31,104,30,54,31,1,31,222,31,144,31,95,31,92,31,219,31,219,30,46,31,124,31,124,30,116,31,116,30,131,31,121,31,121,30,200,31,200,30,200,29,96,31,86,31,86,30,21,31,93,31,150,31,83,31,212,31,212,30,57,31,182,31,237,31,237,30,167,31,167,30,167,29,167,28,243,31,231,31,46,31,33,31,1,31,44,31,12,31,12,30,23,31,96,31,181,31,238,31,80,31,56,31,104,31,104,30,241,31,55,31,55,30,48,31,192,31,207,31,22,31,71,31,71,30,118,31,150,31,154,31,154,30,207,31,219,31,84,31,189,31,231,31,53,31,200,31,200,30,200,29,87,31,6,31,200,31,26,31,26,30,26,29,64,31,100,31,217,31,167,31,109,31,205,31,115,31,235,31,113,31,29,31,29,30,37,31,57,31,57,30,133,31,104,31,164,31,158,31,152,31,240,31,240,30,29,31,79,31,72,31,94,31,155,31,155,30,155,29,28,31,93,31,170,31,243,31,38,31,168,31,144,31,107,31,249,31,64,31,210,31,58,31,26,31,4,31,131,31,44,31,244,31,158,31,246,31,252,31,154,31,118,31,252,31,202,31,121,31,115,31,75,31,201,31,234,31,35,31,190,31,70,31,70,30,199,31,214,31,141,31,42,31,230,31,72,31,107,31,246,31,67,31,105,31,93,31,93,30,93,29,202,31,191,31,229,31,94,31,99,31,7,31,102,31,219,31,210,31,127,31,214,31,115,31,36,31,36,30,255,31,255,30,244,31,48,31,48,30,48,29,199,31,159,31,163,31,78,31,27,31,27,30,141,31,197,31,80,31,80,30,80,29,235,31,253,31,218,31,235,31,204,31,184,31,184,30,141,31,141,30,152,31,207,31,94,31,102,31,34,31,120,31,120,30,73,31,180,31,180,30,75,31,71,31,148,31,206,31,111,31,88,31,88,30,160,31,114,31,185,31,181,31,4,31,4,30,210,31,59,31,90,31,90,30,9,31,12,31,213,31,151,31,198,31,184,31,31,31,153,31,50,31,50,30,50,29,74,31,29,31,250,31,198,31,128,31,53,31,93,31,247,31,247,30,247,29,247,28,236,31,115,31,116,31,115,31,132,31,202,31,202,30,202,29,203,31,39,31,39,30,203,31,189,31,117,31,117,30,13,31,225,31,63,31,102,31,191,31,242,31,182,31,209,31,209,30,9,31,253,31,77,31,18,31,91,31,91,30,237,31,44,31,44,30,44,29,226,31,2,31,2,30,2,29,20,31,20,30,234,31,234,30,194,31,181,31,181,30,190,31,226,31,221,31,179,31,169,31,12,31,52,31,148,31,186,31,218,31,218,30,119,31,106,31,248,31,211,31,211,30,239,31,239,30,239,29,3,31,42,31,215,31,174,31,168,31,171,31,63,31,63,30,63,29,236,31,180,31,237,31,135,31,12,31,12,30,12,29,13,31,32,31,158,31,51,31,94,31,94,30,73,31,37,31,37,30,199,31,68,31,108,31,207,31,37,31,244,31,142,31,38,31,16,31,134,31,87,31,87,30,37,31,156,31,124,31,143,31,164,31,29,31,113,31,3,31,138,31,54,31,91,31,171,31,141,31,71,31,71,30,245,31,211,31,230,31,10,31,232,31,142,31,5,31,253,31,204,31,211,31,120,31,111,31,233,31,233,30,233,29,221,31,192,31,235,31,154,31,237,31,237,30,31,31,31,30,226,31,106,31,56,31,56,30,133,31,255,31,112,31,46,31,11,31,11,30,164,31,38,31,65,31,219,31,227,31,161,31);

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
