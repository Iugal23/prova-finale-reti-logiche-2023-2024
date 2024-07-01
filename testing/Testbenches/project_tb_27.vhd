-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_27 is
end project_tb_27;

architecture project_tb_arch_27 of project_tb_27 is
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

constant SCENARIO_LENGTH : integer := 511;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (129,0,0,0,161,0,100,0,15,0,40,0,0,0,104,0,245,0,109,0,0,0,0,0,93,0,252,0,38,0,84,0,239,0,0,0,0,0,183,0,207,0,36,0,49,0,0,0,73,0,16,0,0,0,26,0,83,0,132,0,150,0,135,0,78,0,225,0,247,0,239,0,0,0,39,0,48,0,0,0,254,0,135,0,46,0,0,0,250,0,71,0,95,0,152,0,36,0,74,0,123,0,214,0,24,0,173,0,0,0,129,0,225,0,0,0,0,0,0,0,0,0,82,0,222,0,122,0,209,0,0,0,104,0,61,0,201,0,53,0,103,0,0,0,9,0,216,0,233,0,0,0,243,0,172,0,242,0,77,0,195,0,145,0,249,0,152,0,83,0,253,0,223,0,153,0,90,0,0,0,242,0,205,0,0,0,41,0,22,0,85,0,0,0,184,0,234,0,36,0,0,0,93,0,0,0,112,0,250,0,30,0,67,0,196,0,156,0,57,0,240,0,236,0,133,0,48,0,21,0,129,0,251,0,224,0,0,0,108,0,238,0,11,0,0,0,19,0,0,0,0,0,23,0,167,0,228,0,106,0,87,0,211,0,134,0,45,0,0,0,96,0,13,0,246,0,0,0,114,0,112,0,125,0,110,0,249,0,60,0,0,0,63,0,200,0,89,0,140,0,193,0,123,0,118,0,63,0,229,0,171,0,0,0,54,0,158,0,59,0,22,0,150,0,54,0,86,0,0,0,192,0,155,0,162,0,32,0,176,0,254,0,162,0,212,0,0,0,4,0,10,0,0,0,42,0,207,0,46,0,0,0,0,0,41,0,144,0,206,0,92,0,74,0,48,0,64,0,92,0,91,0,9,0,183,0,0,0,38,0,0,0,0,0,23,0,151,0,51,0,91,0,243,0,0,0,33,0,0,0,43,0,152,0,180,0,132,0,59,0,198,0,197,0,120,0,202,0,0,0,128,0,125,0,199,0,115,0,59,0,11,0,0,0,220,0,23,0,28,0,173,0,142,0,157,0,0,0,137,0,61,0,0,0,9,0,4,0,211,0,133,0,114,0,112,0,246,0,13,0,90,0,48,0,248,0,196,0,205,0,235,0,0,0,27,0,103,0,189,0,109,0,212,0,25,0,246,0,79,0,0,0,19,0,203,0,65,0,0,0,14,0,141,0,54,0,37,0,0,0,89,0,149,0,0,0,59,0,112,0,187,0,94,0,84,0,144,0,220,0,14,0,40,0,83,0,244,0,0,0,69,0,2,0,0,0,0,0,21,0,252,0,0,0,0,0,212,0,72,0,99,0,185,0,0,0,212,0,0,0,14,0,186,0,48,0,66,0,216,0,189,0,0,0,147,0,141,0,12,0,109,0,117,0,0,0,44,0,147,0,111,0,135,0,32,0,177,0,162,0,165,0,215,0,192,0,213,0,0,0,185,0,169,0,55,0,0,0,232,0,0,0,35,0,151,0,114,0,207,0,29,0,29,0,121,0,92,0,80,0,97,0,167,0,0,0,36,0,108,0,187,0,235,0,112,0,23,0,191,0,123,0,0,0,0,0,102,0,211,0,83,0,67,0,117,0,30,0,135,0,0,0,97,0,72,0,52,0,209,0,163,0,180,0,154,0,117,0,123,0,111,0,167,0,255,0,125,0,68,0,236,0,51,0,206,0,14,0,146,0,71,0,0,0,108,0,221,0,59,0,164,0,120,0,162,0,0,0,209,0,170,0,0,0,216,0,226,0,27,0,45,0,0,0,0,0,82,0,103,0,19,0,212,0,141,0,161,0,146,0,61,0,14,0,109,0,99,0,0,0,161,0,152,0,193,0,181,0,102,0,152,0,9,0,0,0,0,0,59,0,218,0,130,0,171,0,154,0,235,0,203,0,98,0,0,0,164,0,189,0,185,0,116,0,166,0,230,0,131,0,181,0,135,0,56,0,113,0,243,0,172,0,179,0,16,0,190,0,127,0,246,0,204,0,227,0,110,0,0,0,100,0,155,0,63,0,193,0,125,0,6,0,53,0,0,0,135,0,12,0,199,0,140,0,0,0,109,0,187,0,94,0,188,0,189,0,219,0,143,0,0,0,208,0,137,0,149,0,68,0,0,0,36,0,73,0,137,0,153,0,34,0,0,0,0,0,154,0,143,0,0,0,191,0,119,0,0,0,130,0,1,0,35,0,204,0,0,0,40,0,45,0,114,0,122,0,116,0,0,0,31,0,0,0,0,0,171,0,74,0,0,0,0,0,86,0,0,0,224,0,236,0,150,0,45,0,2,0,78,0,235,0);
signal scenario_full  : scenario_type := (129,31,129,30,161,31,100,31,15,31,40,31,40,30,104,31,245,31,109,31,109,30,109,29,93,31,252,31,38,31,84,31,239,31,239,30,239,29,183,31,207,31,36,31,49,31,49,30,73,31,16,31,16,30,26,31,83,31,132,31,150,31,135,31,78,31,225,31,247,31,239,31,239,30,39,31,48,31,48,30,254,31,135,31,46,31,46,30,250,31,71,31,95,31,152,31,36,31,74,31,123,31,214,31,24,31,173,31,173,30,129,31,225,31,225,30,225,29,225,28,225,27,82,31,222,31,122,31,209,31,209,30,104,31,61,31,201,31,53,31,103,31,103,30,9,31,216,31,233,31,233,30,243,31,172,31,242,31,77,31,195,31,145,31,249,31,152,31,83,31,253,31,223,31,153,31,90,31,90,30,242,31,205,31,205,30,41,31,22,31,85,31,85,30,184,31,234,31,36,31,36,30,93,31,93,30,112,31,250,31,30,31,67,31,196,31,156,31,57,31,240,31,236,31,133,31,48,31,21,31,129,31,251,31,224,31,224,30,108,31,238,31,11,31,11,30,19,31,19,30,19,29,23,31,167,31,228,31,106,31,87,31,211,31,134,31,45,31,45,30,96,31,13,31,246,31,246,30,114,31,112,31,125,31,110,31,249,31,60,31,60,30,63,31,200,31,89,31,140,31,193,31,123,31,118,31,63,31,229,31,171,31,171,30,54,31,158,31,59,31,22,31,150,31,54,31,86,31,86,30,192,31,155,31,162,31,32,31,176,31,254,31,162,31,212,31,212,30,4,31,10,31,10,30,42,31,207,31,46,31,46,30,46,29,41,31,144,31,206,31,92,31,74,31,48,31,64,31,92,31,91,31,9,31,183,31,183,30,38,31,38,30,38,29,23,31,151,31,51,31,91,31,243,31,243,30,33,31,33,30,43,31,152,31,180,31,132,31,59,31,198,31,197,31,120,31,202,31,202,30,128,31,125,31,199,31,115,31,59,31,11,31,11,30,220,31,23,31,28,31,173,31,142,31,157,31,157,30,137,31,61,31,61,30,9,31,4,31,211,31,133,31,114,31,112,31,246,31,13,31,90,31,48,31,248,31,196,31,205,31,235,31,235,30,27,31,103,31,189,31,109,31,212,31,25,31,246,31,79,31,79,30,19,31,203,31,65,31,65,30,14,31,141,31,54,31,37,31,37,30,89,31,149,31,149,30,59,31,112,31,187,31,94,31,84,31,144,31,220,31,14,31,40,31,83,31,244,31,244,30,69,31,2,31,2,30,2,29,21,31,252,31,252,30,252,29,212,31,72,31,99,31,185,31,185,30,212,31,212,30,14,31,186,31,48,31,66,31,216,31,189,31,189,30,147,31,141,31,12,31,109,31,117,31,117,30,44,31,147,31,111,31,135,31,32,31,177,31,162,31,165,31,215,31,192,31,213,31,213,30,185,31,169,31,55,31,55,30,232,31,232,30,35,31,151,31,114,31,207,31,29,31,29,31,121,31,92,31,80,31,97,31,167,31,167,30,36,31,108,31,187,31,235,31,112,31,23,31,191,31,123,31,123,30,123,29,102,31,211,31,83,31,67,31,117,31,30,31,135,31,135,30,97,31,72,31,52,31,209,31,163,31,180,31,154,31,117,31,123,31,111,31,167,31,255,31,125,31,68,31,236,31,51,31,206,31,14,31,146,31,71,31,71,30,108,31,221,31,59,31,164,31,120,31,162,31,162,30,209,31,170,31,170,30,216,31,226,31,27,31,45,31,45,30,45,29,82,31,103,31,19,31,212,31,141,31,161,31,146,31,61,31,14,31,109,31,99,31,99,30,161,31,152,31,193,31,181,31,102,31,152,31,9,31,9,30,9,29,59,31,218,31,130,31,171,31,154,31,235,31,203,31,98,31,98,30,164,31,189,31,185,31,116,31,166,31,230,31,131,31,181,31,135,31,56,31,113,31,243,31,172,31,179,31,16,31,190,31,127,31,246,31,204,31,227,31,110,31,110,30,100,31,155,31,63,31,193,31,125,31,6,31,53,31,53,30,135,31,12,31,199,31,140,31,140,30,109,31,187,31,94,31,188,31,189,31,219,31,143,31,143,30,208,31,137,31,149,31,68,31,68,30,36,31,73,31,137,31,153,31,34,31,34,30,34,29,154,31,143,31,143,30,191,31,119,31,119,30,130,31,1,31,35,31,204,31,204,30,40,31,45,31,114,31,122,31,116,31,116,30,31,31,31,30,31,29,171,31,74,31,74,30,74,29,86,31,86,30,224,31,236,31,150,31,45,31,2,31,78,31,235,31);

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
