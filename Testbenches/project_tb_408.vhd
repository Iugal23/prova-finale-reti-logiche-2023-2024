-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_408 is
end project_tb_408;

architecture project_tb_arch_408 of project_tb_408 is
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

constant SCENARIO_LENGTH : integer := 789;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (10,0,153,0,230,0,124,0,84,0,0,0,14,0,43,0,174,0,0,0,181,0,0,0,141,0,112,0,84,0,30,0,15,0,115,0,73,0,173,0,127,0,193,0,215,0,254,0,0,0,0,0,217,0,0,0,18,0,54,0,0,0,214,0,56,0,0,0,0,0,137,0,0,0,125,0,175,0,89,0,112,0,229,0,76,0,0,0,244,0,193,0,0,0,250,0,0,0,99,0,119,0,0,0,152,0,199,0,0,0,52,0,218,0,0,0,253,0,115,0,193,0,215,0,0,0,0,0,70,0,223,0,0,0,185,0,221,0,0,0,86,0,0,0,0,0,0,0,0,0,106,0,177,0,200,0,0,0,228,0,108,0,0,0,52,0,184,0,16,0,0,0,31,0,0,0,188,0,204,0,0,0,17,0,38,0,90,0,0,0,54,0,244,0,196,0,68,0,55,0,246,0,219,0,90,0,35,0,228,0,84,0,0,0,0,0,95,0,0,0,0,0,52,0,35,0,4,0,171,0,201,0,183,0,12,0,106,0,181,0,141,0,63,0,54,0,95,0,0,0,86,0,0,0,0,0,125,0,0,0,0,0,0,0,0,0,0,0,208,0,0,0,251,0,95,0,0,0,38,0,126,0,222,0,57,0,181,0,108,0,117,0,83,0,189,0,248,0,120,0,248,0,20,0,24,0,0,0,229,0,55,0,179,0,0,0,36,0,49,0,232,0,78,0,214,0,6,0,62,0,0,0,123,0,217,0,169,0,0,0,13,0,0,0,90,0,0,0,0,0,121,0,191,0,24,0,5,0,147,0,31,0,109,0,151,0,183,0,89,0,251,0,4,0,20,0,212,0,34,0,142,0,0,0,0,0,84,0,195,0,38,0,19,0,65,0,57,0,130,0,206,0,23,0,38,0,133,0,148,0,81,0,5,0,63,0,224,0,138,0,0,0,34,0,5,0,0,0,53,0,116,0,0,0,0,0,9,0,172,0,0,0,226,0,0,0,31,0,243,0,0,0,252,0,0,0,253,0,26,0,213,0,111,0,168,0,168,0,99,0,41,0,0,0,94,0,16,0,206,0,140,0,0,0,171,0,89,0,122,0,99,0,48,0,7,0,32,0,10,0,191,0,214,0,137,0,200,0,66,0,0,0,239,0,0,0,131,0,76,0,189,0,0,0,56,0,49,0,255,0,0,0,236,0,251,0,254,0,189,0,89,0,86,0,126,0,0,0,217,0,119,0,0,0,98,0,0,0,122,0,213,0,149,0,113,0,9,0,195,0,0,0,0,0,0,0,0,0,240,0,134,0,206,0,39,0,245,0,21,0,176,0,255,0,199,0,91,0,101,0,0,0,77,0,81,0,0,0,194,0,163,0,232,0,16,0,163,0,127,0,138,0,7,0,50,0,32,0,0,0,116,0,188,0,1,0,222,0,39,0,86,0,78,0,13,0,170,0,40,0,77,0,0,0,0,0,194,0,63,0,0,0,190,0,211,0,17,0,188,0,111,0,36,0,116,0,247,0,0,0,185,0,92,0,1,0,51,0,133,0,61,0,188,0,0,0,6,0,201,0,52,0,36,0,238,0,120,0,140,0,0,0,139,0,131,0,165,0,29,0,58,0,211,0,243,0,40,0,72,0,0,0,96,0,0,0,58,0,111,0,34,0,236,0,7,0,255,0,0,0,179,0,41,0,36,0,42,0,178,0,96,0,66,0,148,0,0,0,0,0,120,0,134,0,0,0,196,0,0,0,0,0,0,0,144,0,112,0,220,0,158,0,190,0,20,0,97,0,64,0,252,0,114,0,120,0,112,0,0,0,43,0,0,0,53,0,0,0,82,0,138,0,14,0,250,0,174,0,0,0,202,0,252,0,18,0,253,0,174,0,0,0,149,0,195,0,0,0,82,0,73,0,144,0,148,0,40,0,137,0,0,0,160,0,184,0,35,0,231,0,176,0,156,0,17,0,84,0,251,0,82,0,0,0,210,0,97,0,161,0,163,0,246,0,219,0,107,0,149,0,66,0,166,0,222,0,0,0,53,0,204,0,162,0,68,0,219,0,129,0,77,0,154,0,116,0,11,0,0,0,59,0,155,0,200,0,183,0,159,0,227,0,204,0,255,0,0,0,47,0,80,0,165,0,25,0,155,0,53,0,136,0,196,0,97,0,11,0,21,0,209,0,251,0,54,0,67,0,59,0,56,0,172,0,118,0,148,0,168,0,227,0,0,0,141,0,49,0,161,0,112,0,0,0,0,0,49,0,0,0,168,0,213,0,20,0,253,0,175,0,184,0,204,0,130,0,0,0,0,0,87,0,107,0,18,0,104,0,153,0,46,0,0,0,191,0,98,0,209,0,213,0,73,0,244,0,0,0,171,0,34,0,217,0,49,0,117,0,102,0,59,0,80,0,225,0,118,0,154,0,207,0,0,0,28,0,197,0,24,0,0,0,24,0,121,0,124,0,174,0,64,0,100,0,160,0,185,0,180,0,141,0,0,0,148,0,28,0,42,0,188,0,119,0,104,0,75,0,151,0,0,0,99,0,0,0,122,0,0,0,31,0,37,0,117,0,0,0,0,0,71,0,3,0,33,0,173,0,20,0,20,0,47,0,106,0,135,0,0,0,59,0,0,0,0,0,87,0,207,0,0,0,220,0,113,0,0,0,0,0,32,0,162,0,234,0,137,0,67,0,225,0,149,0,236,0,249,0,211,0,0,0,66,0,147,0,152,0,250,0,188,0,101,0,141,0,67,0,251,0,207,0,0,0,219,0,183,0,23,0,190,0,57,0,110,0,208,0,206,0,23,0,162,0,51,0,6,0,0,0,100,0,6,0,9,0,103,0,0,0,71,0,69,0,114,0,237,0,155,0,252,0,0,0,0,0,0,0,49,0,205,0,107,0,0,0,0,0,104,0,0,0,198,0,198,0,0,0,185,0,238,0,0,0,0,0,125,0,5,0,171,0,56,0,86,0,42,0,111,0,38,0,126,0,0,0,200,0,0,0,164,0,0,0,82,0,72,0,86,0,183,0,0,0,25,0,178,0,138,0,0,0,0,0,211,0,102,0,0,0,30,0,0,0,244,0,92,0,0,0,0,0,47,0,78,0,60,0,68,0,34,0,92,0,9,0,12,0,144,0,2,0,209,0,145,0,0,0,59,0,0,0,93,0,113,0,0,0,0,0,0,0,76,0,195,0,203,0,245,0,0,0,240,0,0,0,238,0,242,0,86,0,151,0,142,0,0,0,141,0,139,0,0,0,42,0,40,0,83,0,34,0,157,0,60,0,189,0,114,0,206,0,131,0,0,0,27,0,0,0,0,0,78,0,0,0,0,0,160,0,37,0,98,0,0,0,0,0,249,0,122,0,74,0,228,0,0,0,59,0,178,0,24,0,143,0,0,0,0,0,36,0,94,0,6,0,30,0,115,0,89,0,143,0,216,0,47,0,0,0,162,0,45,0,174,0,247,0,9,0,0,0,0,0,41,0,141,0,0,0,135,0,0,0,224,0,93,0,248,0,84,0,37,0,31,0,18,0);
signal scenario_full  : scenario_type := (10,31,153,31,230,31,124,31,84,31,84,30,14,31,43,31,174,31,174,30,181,31,181,30,141,31,112,31,84,31,30,31,15,31,115,31,73,31,173,31,127,31,193,31,215,31,254,31,254,30,254,29,217,31,217,30,18,31,54,31,54,30,214,31,56,31,56,30,56,29,137,31,137,30,125,31,175,31,89,31,112,31,229,31,76,31,76,30,244,31,193,31,193,30,250,31,250,30,99,31,119,31,119,30,152,31,199,31,199,30,52,31,218,31,218,30,253,31,115,31,193,31,215,31,215,30,215,29,70,31,223,31,223,30,185,31,221,31,221,30,86,31,86,30,86,29,86,28,86,27,106,31,177,31,200,31,200,30,228,31,108,31,108,30,52,31,184,31,16,31,16,30,31,31,31,30,188,31,204,31,204,30,17,31,38,31,90,31,90,30,54,31,244,31,196,31,68,31,55,31,246,31,219,31,90,31,35,31,228,31,84,31,84,30,84,29,95,31,95,30,95,29,52,31,35,31,4,31,171,31,201,31,183,31,12,31,106,31,181,31,141,31,63,31,54,31,95,31,95,30,86,31,86,30,86,29,125,31,125,30,125,29,125,28,125,27,125,26,208,31,208,30,251,31,95,31,95,30,38,31,126,31,222,31,57,31,181,31,108,31,117,31,83,31,189,31,248,31,120,31,248,31,20,31,24,31,24,30,229,31,55,31,179,31,179,30,36,31,49,31,232,31,78,31,214,31,6,31,62,31,62,30,123,31,217,31,169,31,169,30,13,31,13,30,90,31,90,30,90,29,121,31,191,31,24,31,5,31,147,31,31,31,109,31,151,31,183,31,89,31,251,31,4,31,20,31,212,31,34,31,142,31,142,30,142,29,84,31,195,31,38,31,19,31,65,31,57,31,130,31,206,31,23,31,38,31,133,31,148,31,81,31,5,31,63,31,224,31,138,31,138,30,34,31,5,31,5,30,53,31,116,31,116,30,116,29,9,31,172,31,172,30,226,31,226,30,31,31,243,31,243,30,252,31,252,30,253,31,26,31,213,31,111,31,168,31,168,31,99,31,41,31,41,30,94,31,16,31,206,31,140,31,140,30,171,31,89,31,122,31,99,31,48,31,7,31,32,31,10,31,191,31,214,31,137,31,200,31,66,31,66,30,239,31,239,30,131,31,76,31,189,31,189,30,56,31,49,31,255,31,255,30,236,31,251,31,254,31,189,31,89,31,86,31,126,31,126,30,217,31,119,31,119,30,98,31,98,30,122,31,213,31,149,31,113,31,9,31,195,31,195,30,195,29,195,28,195,27,240,31,134,31,206,31,39,31,245,31,21,31,176,31,255,31,199,31,91,31,101,31,101,30,77,31,81,31,81,30,194,31,163,31,232,31,16,31,163,31,127,31,138,31,7,31,50,31,32,31,32,30,116,31,188,31,1,31,222,31,39,31,86,31,78,31,13,31,170,31,40,31,77,31,77,30,77,29,194,31,63,31,63,30,190,31,211,31,17,31,188,31,111,31,36,31,116,31,247,31,247,30,185,31,92,31,1,31,51,31,133,31,61,31,188,31,188,30,6,31,201,31,52,31,36,31,238,31,120,31,140,31,140,30,139,31,131,31,165,31,29,31,58,31,211,31,243,31,40,31,72,31,72,30,96,31,96,30,58,31,111,31,34,31,236,31,7,31,255,31,255,30,179,31,41,31,36,31,42,31,178,31,96,31,66,31,148,31,148,30,148,29,120,31,134,31,134,30,196,31,196,30,196,29,196,28,144,31,112,31,220,31,158,31,190,31,20,31,97,31,64,31,252,31,114,31,120,31,112,31,112,30,43,31,43,30,53,31,53,30,82,31,138,31,14,31,250,31,174,31,174,30,202,31,252,31,18,31,253,31,174,31,174,30,149,31,195,31,195,30,82,31,73,31,144,31,148,31,40,31,137,31,137,30,160,31,184,31,35,31,231,31,176,31,156,31,17,31,84,31,251,31,82,31,82,30,210,31,97,31,161,31,163,31,246,31,219,31,107,31,149,31,66,31,166,31,222,31,222,30,53,31,204,31,162,31,68,31,219,31,129,31,77,31,154,31,116,31,11,31,11,30,59,31,155,31,200,31,183,31,159,31,227,31,204,31,255,31,255,30,47,31,80,31,165,31,25,31,155,31,53,31,136,31,196,31,97,31,11,31,21,31,209,31,251,31,54,31,67,31,59,31,56,31,172,31,118,31,148,31,168,31,227,31,227,30,141,31,49,31,161,31,112,31,112,30,112,29,49,31,49,30,168,31,213,31,20,31,253,31,175,31,184,31,204,31,130,31,130,30,130,29,87,31,107,31,18,31,104,31,153,31,46,31,46,30,191,31,98,31,209,31,213,31,73,31,244,31,244,30,171,31,34,31,217,31,49,31,117,31,102,31,59,31,80,31,225,31,118,31,154,31,207,31,207,30,28,31,197,31,24,31,24,30,24,31,121,31,124,31,174,31,64,31,100,31,160,31,185,31,180,31,141,31,141,30,148,31,28,31,42,31,188,31,119,31,104,31,75,31,151,31,151,30,99,31,99,30,122,31,122,30,31,31,37,31,117,31,117,30,117,29,71,31,3,31,33,31,173,31,20,31,20,31,47,31,106,31,135,31,135,30,59,31,59,30,59,29,87,31,207,31,207,30,220,31,113,31,113,30,113,29,32,31,162,31,234,31,137,31,67,31,225,31,149,31,236,31,249,31,211,31,211,30,66,31,147,31,152,31,250,31,188,31,101,31,141,31,67,31,251,31,207,31,207,30,219,31,183,31,23,31,190,31,57,31,110,31,208,31,206,31,23,31,162,31,51,31,6,31,6,30,100,31,6,31,9,31,103,31,103,30,71,31,69,31,114,31,237,31,155,31,252,31,252,30,252,29,252,28,49,31,205,31,107,31,107,30,107,29,104,31,104,30,198,31,198,31,198,30,185,31,238,31,238,30,238,29,125,31,5,31,171,31,56,31,86,31,42,31,111,31,38,31,126,31,126,30,200,31,200,30,164,31,164,30,82,31,72,31,86,31,183,31,183,30,25,31,178,31,138,31,138,30,138,29,211,31,102,31,102,30,30,31,30,30,244,31,92,31,92,30,92,29,47,31,78,31,60,31,68,31,34,31,92,31,9,31,12,31,144,31,2,31,209,31,145,31,145,30,59,31,59,30,93,31,113,31,113,30,113,29,113,28,76,31,195,31,203,31,245,31,245,30,240,31,240,30,238,31,242,31,86,31,151,31,142,31,142,30,141,31,139,31,139,30,42,31,40,31,83,31,34,31,157,31,60,31,189,31,114,31,206,31,131,31,131,30,27,31,27,30,27,29,78,31,78,30,78,29,160,31,37,31,98,31,98,30,98,29,249,31,122,31,74,31,228,31,228,30,59,31,178,31,24,31,143,31,143,30,143,29,36,31,94,31,6,31,30,31,115,31,89,31,143,31,216,31,47,31,47,30,162,31,45,31,174,31,247,31,9,31,9,30,9,29,41,31,141,31,141,30,135,31,135,30,224,31,93,31,248,31,84,31,37,31,31,31,18,31);

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
