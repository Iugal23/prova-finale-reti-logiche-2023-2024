-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_540 is
end project_tb_540;

architecture project_tb_arch_540 of project_tb_540 is
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

constant SCENARIO_LENGTH : integer := 812;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (57,0,12,0,37,0,0,0,80,0,153,0,173,0,0,0,144,0,208,0,124,0,193,0,47,0,62,0,73,0,96,0,101,0,181,0,255,0,209,0,249,0,0,0,127,0,199,0,73,0,148,0,42,0,41,0,0,0,194,0,111,0,141,0,243,0,9,0,17,0,0,0,230,0,132,0,32,0,0,0,22,0,186,0,237,0,111,0,155,0,177,0,158,0,195,0,72,0,110,0,48,0,84,0,98,0,0,0,0,0,108,0,214,0,180,0,103,0,3,0,71,0,56,0,244,0,154,0,91,0,198,0,7,0,125,0,233,0,55,0,49,0,15,0,146,0,0,0,47,0,195,0,169,0,0,0,73,0,19,0,12,0,68,0,11,0,122,0,114,0,236,0,0,0,11,0,49,0,107,0,152,0,126,0,0,0,0,0,209,0,0,0,60,0,78,0,216,0,214,0,182,0,0,0,0,0,117,0,85,0,211,0,70,0,14,0,203,0,0,0,101,0,31,0,189,0,125,0,0,0,112,0,121,0,0,0,181,0,0,0,0,0,143,0,0,0,156,0,0,0,236,0,59,0,25,0,187,0,140,0,67,0,0,0,20,0,108,0,49,0,221,0,58,0,243,0,0,0,218,0,90,0,125,0,171,0,177,0,40,0,136,0,224,0,234,0,250,0,61,0,216,0,145,0,166,0,230,0,86,0,0,0,0,0,38,0,84,0,41,0,146,0,239,0,167,0,231,0,162,0,0,0,0,0,0,0,100,0,135,0,227,0,42,0,162,0,252,0,92,0,0,0,233,0,146,0,64,0,206,0,0,0,192,0,25,0,72,0,199,0,196,0,70,0,211,0,157,0,173,0,81,0,0,0,38,0,118,0,0,0,85,0,71,0,230,0,241,0,244,0,0,0,2,0,67,0,96,0,211,0,40,0,232,0,247,0,2,0,137,0,241,0,124,0,71,0,123,0,151,0,129,0,0,0,187,0,92,0,140,0,92,0,16,0,26,0,15,0,52,0,149,0,216,0,0,0,0,0,79,0,104,0,6,0,215,0,165,0,197,0,0,0,255,0,30,0,14,0,189,0,161,0,147,0,0,0,2,0,80,0,50,0,0,0,18,0,232,0,205,0,112,0,73,0,51,0,235,0,0,0,238,0,0,0,70,0,107,0,0,0,72,0,246,0,0,0,149,0,179,0,211,0,147,0,164,0,160,0,146,0,102,0,249,0,224,0,165,0,16,0,11,0,0,0,50,0,0,0,245,0,178,0,212,0,45,0,0,0,21,0,171,0,219,0,8,0,106,0,143,0,0,0,159,0,235,0,0,0,16,0,0,0,199,0,0,0,0,0,147,0,58,0,170,0,221,0,94,0,46,0,56,0,110,0,35,0,0,0,228,0,194,0,0,0,108,0,87,0,11,0,32,0,99,0,205,0,224,0,181,0,205,0,219,0,236,0,0,0,65,0,82,0,52,0,0,0,61,0,0,0,229,0,102,0,214,0,23,0,102,0,0,0,111,0,25,0,219,0,122,0,19,0,63,0,0,0,202,0,0,0,46,0,0,0,244,0,41,0,38,0,84,0,15,0,232,0,0,0,46,0,63,0,250,0,232,0,249,0,181,0,0,0,35,0,121,0,243,0,0,0,183,0,65,0,0,0,71,0,0,0,116,0,120,0,58,0,0,0,108,0,146,0,105,0,93,0,93,0,57,0,0,0,0,0,198,0,32,0,97,0,0,0,202,0,38,0,227,0,35,0,0,0,54,0,78,0,208,0,77,0,55,0,8,0,83,0,67,0,192,0,0,0,7,0,130,0,154,0,59,0,248,0,157,0,98,0,237,0,61,0,0,0,194,0,204,0,116,0,185,0,107,0,0,0,93,0,123,0,0,0,181,0,163,0,0,0,49,0,89,0,209,0,0,0,26,0,255,0,84,0,0,0,44,0,23,0,121,0,74,0,110,0,252,0,0,0,250,0,0,0,235,0,213,0,110,0,0,0,100,0,72,0,0,0,13,0,15,0,0,0,7,0,14,0,0,0,255,0,0,0,221,0,15,0,0,0,110,0,70,0,29,0,163,0,126,0,115,0,18,0,157,0,101,0,137,0,75,0,121,0,0,0,186,0,136,0,155,0,0,0,0,0,205,0,169,0,3,0,129,0,21,0,219,0,105,0,200,0,193,0,161,0,28,0,167,0,48,0,0,0,248,0,10,0,169,0,0,0,83,0,62,0,219,0,75,0,0,0,42,0,210,0,145,0,0,0,0,0,0,0,0,0,67,0,255,0,114,0,88,0,110,0,131,0,81,0,104,0,34,0,0,0,0,0,106,0,0,0,8,0,170,0,254,0,0,0,141,0,248,0,217,0,160,0,3,0,30,0,0,0,0,0,0,0,232,0,134,0,51,0,0,0,220,0,164,0,239,0,91,0,23,0,2,0,0,0,17,0,113,0,48,0,0,0,66,0,63,0,226,0,208,0,184,0,7,0,2,0,0,0,186,0,18,0,238,0,0,0,125,0,0,0,237,0,7,0,75,0,205,0,0,0,51,0,127,0,39,0,0,0,144,0,30,0,146,0,230,0,92,0,127,0,0,0,56,0,133,0,137,0,130,0,178,0,173,0,245,0,222,0,116,0,163,0,240,0,161,0,37,0,0,0,7,0,83,0,105,0,114,0,25,0,0,0,253,0,171,0,0,0,145,0,222,0,63,0,0,0,142,0,224,0,180,0,245,0,0,0,102,0,130,0,60,0,0,0,0,0,242,0,168,0,129,0,0,0,169,0,0,0,0,0,6,0,196,0,162,0,246,0,230,0,29,0,245,0,139,0,0,0,215,0,238,0,136,0,162,0,160,0,83,0,219,0,0,0,0,0,0,0,0,0,202,0,166,0,61,0,0,0,0,0,85,0,6,0,137,0,127,0,0,0,17,0,183,0,177,0,184,0,0,0,45,0,9,0,140,0,170,0,190,0,0,0,0,0,155,0,200,0,249,0,154,0,168,0,239,0,102,0,153,0,243,0,42,0,0,0,90,0,189,0,7,0,250,0,18,0,172,0,63,0,55,0,182,0,8,0,31,0,121,0,60,0,140,0,159,0,0,0,42,0,195,0,215,0,0,0,115,0,0,0,0,0,165,0,154,0,181,0,166,0,12,0,204,0,236,0,39,0,39,0,183,0,245,0,0,0,104,0,156,0,180,0,72,0,244,0,153,0,0,0,98,0,0,0,133,0,83,0,251,0,63,0,192,0,248,0,144,0,141,0,0,0,0,0,199,0,165,0,0,0,9,0,106,0,218,0,125,0,90,0,64,0,235,0,62,0,229,0,99,0,45,0,68,0,61,0,235,0,184,0,132,0,114,0,181,0,231,0,44,0,244,0,37,0,13,0,134,0,168,0,0,0,51,0,22,0,0,0,250,0,0,0,234,0,53,0,23,0,77,0,223,0,50,0,0,0,63,0,56,0,79,0,133,0,195,0,0,0,223,0,161,0,103,0,0,0,242,0,243,0,12,0,42,0,195,0,222,0,56,0,231,0,137,0,60,0,0,0,83,0,0,0,28,0,183,0,0,0,178,0,81,0,251,0,241,0,79,0,247,0,43,0,0,0,0,0,34,0,167,0,133,0,222,0,21,0,0,0,43,0,5,0);
signal scenario_full  : scenario_type := (57,31,12,31,37,31,37,30,80,31,153,31,173,31,173,30,144,31,208,31,124,31,193,31,47,31,62,31,73,31,96,31,101,31,181,31,255,31,209,31,249,31,249,30,127,31,199,31,73,31,148,31,42,31,41,31,41,30,194,31,111,31,141,31,243,31,9,31,17,31,17,30,230,31,132,31,32,31,32,30,22,31,186,31,237,31,111,31,155,31,177,31,158,31,195,31,72,31,110,31,48,31,84,31,98,31,98,30,98,29,108,31,214,31,180,31,103,31,3,31,71,31,56,31,244,31,154,31,91,31,198,31,7,31,125,31,233,31,55,31,49,31,15,31,146,31,146,30,47,31,195,31,169,31,169,30,73,31,19,31,12,31,68,31,11,31,122,31,114,31,236,31,236,30,11,31,49,31,107,31,152,31,126,31,126,30,126,29,209,31,209,30,60,31,78,31,216,31,214,31,182,31,182,30,182,29,117,31,85,31,211,31,70,31,14,31,203,31,203,30,101,31,31,31,189,31,125,31,125,30,112,31,121,31,121,30,181,31,181,30,181,29,143,31,143,30,156,31,156,30,236,31,59,31,25,31,187,31,140,31,67,31,67,30,20,31,108,31,49,31,221,31,58,31,243,31,243,30,218,31,90,31,125,31,171,31,177,31,40,31,136,31,224,31,234,31,250,31,61,31,216,31,145,31,166,31,230,31,86,31,86,30,86,29,38,31,84,31,41,31,146,31,239,31,167,31,231,31,162,31,162,30,162,29,162,28,100,31,135,31,227,31,42,31,162,31,252,31,92,31,92,30,233,31,146,31,64,31,206,31,206,30,192,31,25,31,72,31,199,31,196,31,70,31,211,31,157,31,173,31,81,31,81,30,38,31,118,31,118,30,85,31,71,31,230,31,241,31,244,31,244,30,2,31,67,31,96,31,211,31,40,31,232,31,247,31,2,31,137,31,241,31,124,31,71,31,123,31,151,31,129,31,129,30,187,31,92,31,140,31,92,31,16,31,26,31,15,31,52,31,149,31,216,31,216,30,216,29,79,31,104,31,6,31,215,31,165,31,197,31,197,30,255,31,30,31,14,31,189,31,161,31,147,31,147,30,2,31,80,31,50,31,50,30,18,31,232,31,205,31,112,31,73,31,51,31,235,31,235,30,238,31,238,30,70,31,107,31,107,30,72,31,246,31,246,30,149,31,179,31,211,31,147,31,164,31,160,31,146,31,102,31,249,31,224,31,165,31,16,31,11,31,11,30,50,31,50,30,245,31,178,31,212,31,45,31,45,30,21,31,171,31,219,31,8,31,106,31,143,31,143,30,159,31,235,31,235,30,16,31,16,30,199,31,199,30,199,29,147,31,58,31,170,31,221,31,94,31,46,31,56,31,110,31,35,31,35,30,228,31,194,31,194,30,108,31,87,31,11,31,32,31,99,31,205,31,224,31,181,31,205,31,219,31,236,31,236,30,65,31,82,31,52,31,52,30,61,31,61,30,229,31,102,31,214,31,23,31,102,31,102,30,111,31,25,31,219,31,122,31,19,31,63,31,63,30,202,31,202,30,46,31,46,30,244,31,41,31,38,31,84,31,15,31,232,31,232,30,46,31,63,31,250,31,232,31,249,31,181,31,181,30,35,31,121,31,243,31,243,30,183,31,65,31,65,30,71,31,71,30,116,31,120,31,58,31,58,30,108,31,146,31,105,31,93,31,93,31,57,31,57,30,57,29,198,31,32,31,97,31,97,30,202,31,38,31,227,31,35,31,35,30,54,31,78,31,208,31,77,31,55,31,8,31,83,31,67,31,192,31,192,30,7,31,130,31,154,31,59,31,248,31,157,31,98,31,237,31,61,31,61,30,194,31,204,31,116,31,185,31,107,31,107,30,93,31,123,31,123,30,181,31,163,31,163,30,49,31,89,31,209,31,209,30,26,31,255,31,84,31,84,30,44,31,23,31,121,31,74,31,110,31,252,31,252,30,250,31,250,30,235,31,213,31,110,31,110,30,100,31,72,31,72,30,13,31,15,31,15,30,7,31,14,31,14,30,255,31,255,30,221,31,15,31,15,30,110,31,70,31,29,31,163,31,126,31,115,31,18,31,157,31,101,31,137,31,75,31,121,31,121,30,186,31,136,31,155,31,155,30,155,29,205,31,169,31,3,31,129,31,21,31,219,31,105,31,200,31,193,31,161,31,28,31,167,31,48,31,48,30,248,31,10,31,169,31,169,30,83,31,62,31,219,31,75,31,75,30,42,31,210,31,145,31,145,30,145,29,145,28,145,27,67,31,255,31,114,31,88,31,110,31,131,31,81,31,104,31,34,31,34,30,34,29,106,31,106,30,8,31,170,31,254,31,254,30,141,31,248,31,217,31,160,31,3,31,30,31,30,30,30,29,30,28,232,31,134,31,51,31,51,30,220,31,164,31,239,31,91,31,23,31,2,31,2,30,17,31,113,31,48,31,48,30,66,31,63,31,226,31,208,31,184,31,7,31,2,31,2,30,186,31,18,31,238,31,238,30,125,31,125,30,237,31,7,31,75,31,205,31,205,30,51,31,127,31,39,31,39,30,144,31,30,31,146,31,230,31,92,31,127,31,127,30,56,31,133,31,137,31,130,31,178,31,173,31,245,31,222,31,116,31,163,31,240,31,161,31,37,31,37,30,7,31,83,31,105,31,114,31,25,31,25,30,253,31,171,31,171,30,145,31,222,31,63,31,63,30,142,31,224,31,180,31,245,31,245,30,102,31,130,31,60,31,60,30,60,29,242,31,168,31,129,31,129,30,169,31,169,30,169,29,6,31,196,31,162,31,246,31,230,31,29,31,245,31,139,31,139,30,215,31,238,31,136,31,162,31,160,31,83,31,219,31,219,30,219,29,219,28,219,27,202,31,166,31,61,31,61,30,61,29,85,31,6,31,137,31,127,31,127,30,17,31,183,31,177,31,184,31,184,30,45,31,9,31,140,31,170,31,190,31,190,30,190,29,155,31,200,31,249,31,154,31,168,31,239,31,102,31,153,31,243,31,42,31,42,30,90,31,189,31,7,31,250,31,18,31,172,31,63,31,55,31,182,31,8,31,31,31,121,31,60,31,140,31,159,31,159,30,42,31,195,31,215,31,215,30,115,31,115,30,115,29,165,31,154,31,181,31,166,31,12,31,204,31,236,31,39,31,39,31,183,31,245,31,245,30,104,31,156,31,180,31,72,31,244,31,153,31,153,30,98,31,98,30,133,31,83,31,251,31,63,31,192,31,248,31,144,31,141,31,141,30,141,29,199,31,165,31,165,30,9,31,106,31,218,31,125,31,90,31,64,31,235,31,62,31,229,31,99,31,45,31,68,31,61,31,235,31,184,31,132,31,114,31,181,31,231,31,44,31,244,31,37,31,13,31,134,31,168,31,168,30,51,31,22,31,22,30,250,31,250,30,234,31,53,31,23,31,77,31,223,31,50,31,50,30,63,31,56,31,79,31,133,31,195,31,195,30,223,31,161,31,103,31,103,30,242,31,243,31,12,31,42,31,195,31,222,31,56,31,231,31,137,31,60,31,60,30,83,31,83,30,28,31,183,31,183,30,178,31,81,31,251,31,241,31,79,31,247,31,43,31,43,30,43,29,34,31,167,31,133,31,222,31,21,31,21,30,43,31,5,31);

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
