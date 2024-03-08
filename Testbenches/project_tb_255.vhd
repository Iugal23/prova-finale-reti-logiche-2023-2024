-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_255 is
end project_tb_255;

architecture project_tb_arch_255 of project_tb_255 is
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

constant SCENARIO_LENGTH : integer := 811;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (181,0,0,0,0,0,131,0,0,0,0,0,147,0,141,0,60,0,0,0,0,0,231,0,136,0,111,0,190,0,205,0,190,0,229,0,215,0,251,0,0,0,223,0,199,0,154,0,245,0,149,0,119,0,112,0,25,0,28,0,0,0,0,0,127,0,248,0,206,0,120,0,194,0,104,0,221,0,51,0,72,0,132,0,45,0,186,0,81,0,254,0,43,0,0,0,0,0,36,0,140,0,194,0,144,0,77,0,150,0,83,0,35,0,102,0,164,0,69,0,0,0,160,0,0,0,98,0,70,0,123,0,78,0,33,0,0,0,84,0,51,0,52,0,117,0,0,0,55,0,157,0,82,0,115,0,31,0,130,0,161,0,234,0,224,0,95,0,221,0,197,0,0,0,35,0,169,0,107,0,106,0,122,0,239,0,239,0,173,0,0,0,14,0,205,0,89,0,156,0,1,0,0,0,198,0,248,0,0,0,104,0,27,0,0,0,8,0,59,0,46,0,129,0,194,0,226,0,157,0,241,0,208,0,76,0,0,0,189,0,185,0,175,0,170,0,100,0,181,0,72,0,0,0,11,0,223,0,188,0,99,0,98,0,199,0,78,0,100,0,229,0,138,0,0,0,78,0,157,0,1,0,132,0,0,0,37,0,227,0,166,0,177,0,91,0,0,0,192,0,0,0,0,0,0,0,214,0,86,0,173,0,228,0,0,0,135,0,182,0,144,0,170,0,47,0,0,0,244,0,131,0,0,0,229,0,156,0,0,0,24,0,0,0,116,0,106,0,0,0,117,0,0,0,59,0,14,0,129,0,151,0,111,0,230,0,176,0,101,0,107,0,0,0,0,0,0,0,0,0,6,0,7,0,8,0,63,0,153,0,0,0,233,0,216,0,87,0,154,0,4,0,0,0,0,0,183,0,92,0,214,0,164,0,24,0,116,0,73,0,11,0,73,0,163,0,0,0,56,0,119,0,201,0,136,0,168,0,6,0,158,0,158,0,167,0,197,0,96,0,224,0,154,0,26,0,38,0,35,0,234,0,17,0,119,0,94,0,162,0,38,0,46,0,0,0,62,0,110,0,157,0,19,0,166,0,0,0,245,0,187,0,152,0,66,0,211,0,215,0,248,0,104,0,0,0,0,0,162,0,0,0,236,0,146,0,223,0,160,0,5,0,119,0,144,0,0,0,0,0,102,0,218,0,252,0,0,0,0,0,125,0,235,0,236,0,199,0,0,0,194,0,228,0,144,0,0,0,0,0,4,0,84,0,6,0,71,0,36,0,0,0,115,0,0,0,19,0,49,0,0,0,70,0,206,0,23,0,3,0,38,0,98,0,94,0,0,0,197,0,0,0,129,0,197,0,132,0,0,0,238,0,206,0,81,0,140,0,203,0,46,0,57,0,237,0,0,0,152,0,173,0,240,0,55,0,117,0,0,0,181,0,236,0,115,0,0,0,223,0,214,0,103,0,139,0,11,0,234,0,131,0,6,0,178,0,184,0,53,0,76,0,2,0,121,0,17,0,240,0,158,0,95,0,213,0,0,0,182,0,125,0,0,0,43,0,243,0,81,0,164,0,110,0,250,0,186,0,50,0,172,0,25,0,0,0,234,0,117,0,0,0,127,0,0,0,58,0,62,0,13,0,129,0,68,0,13,0,70,0,108,0,27,0,112,0,148,0,0,0,215,0,28,0,174,0,158,0,110,0,186,0,96,0,71,0,0,0,23,0,197,0,181,0,31,0,213,0,0,0,220,0,130,0,15,0,233,0,198,0,222,0,248,0,77,0,0,0,213,0,183,0,80,0,121,0,212,0,147,0,204,0,41,0,100,0,92,0,42,0,63,0,239,0,8,0,0,0,97,0,17,0,0,0,164,0,106,0,45,0,107,0,0,0,0,0,251,0,175,0,151,0,166,0,254,0,9,0,68,0,94,0,98,0,86,0,0,0,40,0,215,0,234,0,176,0,159,0,132,0,0,0,0,0,63,0,243,0,206,0,158,0,248,0,106,0,90,0,74,0,236,0,178,0,216,0,0,0,74,0,0,0,82,0,147,0,172,0,20,0,141,0,38,0,48,0,222,0,48,0,159,0,1,0,4,0,173,0,0,0,49,0,102,0,215,0,37,0,0,0,173,0,197,0,51,0,144,0,0,0,0,0,140,0,120,0,84,0,218,0,204,0,211,0,0,0,67,0,218,0,82,0,0,0,126,0,103,0,220,0,163,0,0,0,50,0,0,0,85,0,152,0,170,0,136,0,67,0,147,0,100,0,0,0,0,0,97,0,176,0,209,0,73,0,141,0,196,0,209,0,21,0,102,0,102,0,2,0,194,0,0,0,0,0,177,0,93,0,0,0,135,0,0,0,55,0,105,0,231,0,58,0,234,0,170,0,165,0,0,0,0,0,0,0,88,0,24,0,80,0,229,0,222,0,127,0,86,0,79,0,124,0,245,0,0,0,194,0,13,0,202,0,42,0,132,0,57,0,76,0,181,0,143,0,135,0,4,0,79,0,12,0,219,0,204,0,177,0,154,0,255,0,0,0,125,0,0,0,215,0,164,0,7,0,119,0,68,0,53,0,24,0,0,0,122,0,57,0,1,0,223,0,0,0,116,0,0,0,80,0,219,0,0,0,128,0,0,0,0,0,189,0,242,0,232,0,145,0,78,0,94,0,0,0,134,0,84,0,60,0,77,0,0,0,21,0,254,0,0,0,116,0,190,0,0,0,56,0,87,0,104,0,239,0,130,0,50,0,0,0,103,0,44,0,116,0,222,0,99,0,233,0,176,0,189,0,207,0,143,0,133,0,137,0,127,0,164,0,55,0,111,0,212,0,76,0,0,0,48,0,0,0,218,0,8,0,0,0,49,0,0,0,0,0,90,0,54,0,173,0,138,0,7,0,0,0,214,0,0,0,87,0,183,0,0,0,81,0,56,0,0,0,0,0,0,0,55,0,222,0,218,0,226,0,150,0,91,0,38,0,29,0,122,0,59,0,82,0,36,0,151,0,76,0,16,0,0,0,0,0,44,0,145,0,0,0,230,0,128,0,63,0,217,0,0,0,253,0,52,0,76,0,97,0,252,0,231,0,102,0,0,0,46,0,223,0,99,0,0,0,185,0,0,0,0,0,80,0,105,0,160,0,242,0,89,0,160,0,0,0,127,0,0,0,96,0,181,0,83,0,9,0,225,0,169,0,194,0,73,0,111,0,241,0,143,0,0,0,227,0,251,0,109,0,177,0,237,0,247,0,198,0,145,0,0,0,70,0,249,0,165,0,232,0,0,0,31,0,0,0,212,0,165,0,0,0,19,0,19,0,0,0,240,0,0,0,37,0,172,0,214,0,48,0,48,0,0,0,230,0,48,0,0,0,177,0,165,0,102,0,60,0,229,0,152,0,235,0,0,0,76,0,174,0,0,0,0,0,0,0,81,0,208,0,129,0,68,0,100,0,23,0,80,0,142,0,0,0,0,0,163,0,0,0,225,0,66,0,155,0,0,0,237,0,0,0,0,0,19,0,12,0,203,0,0,0,32,0,65,0,125,0,0,0,113,0,48,0,0,0,193,0,208,0,5,0,147,0,25,0,226,0,44,0,242,0,165,0,54,0,0,0,0,0,70,0,88,0,90,0,216,0);
signal scenario_full  : scenario_type := (181,31,181,30,181,29,131,31,131,30,131,29,147,31,141,31,60,31,60,30,60,29,231,31,136,31,111,31,190,31,205,31,190,31,229,31,215,31,251,31,251,30,223,31,199,31,154,31,245,31,149,31,119,31,112,31,25,31,28,31,28,30,28,29,127,31,248,31,206,31,120,31,194,31,104,31,221,31,51,31,72,31,132,31,45,31,186,31,81,31,254,31,43,31,43,30,43,29,36,31,140,31,194,31,144,31,77,31,150,31,83,31,35,31,102,31,164,31,69,31,69,30,160,31,160,30,98,31,70,31,123,31,78,31,33,31,33,30,84,31,51,31,52,31,117,31,117,30,55,31,157,31,82,31,115,31,31,31,130,31,161,31,234,31,224,31,95,31,221,31,197,31,197,30,35,31,169,31,107,31,106,31,122,31,239,31,239,31,173,31,173,30,14,31,205,31,89,31,156,31,1,31,1,30,198,31,248,31,248,30,104,31,27,31,27,30,8,31,59,31,46,31,129,31,194,31,226,31,157,31,241,31,208,31,76,31,76,30,189,31,185,31,175,31,170,31,100,31,181,31,72,31,72,30,11,31,223,31,188,31,99,31,98,31,199,31,78,31,100,31,229,31,138,31,138,30,78,31,157,31,1,31,132,31,132,30,37,31,227,31,166,31,177,31,91,31,91,30,192,31,192,30,192,29,192,28,214,31,86,31,173,31,228,31,228,30,135,31,182,31,144,31,170,31,47,31,47,30,244,31,131,31,131,30,229,31,156,31,156,30,24,31,24,30,116,31,106,31,106,30,117,31,117,30,59,31,14,31,129,31,151,31,111,31,230,31,176,31,101,31,107,31,107,30,107,29,107,28,107,27,6,31,7,31,8,31,63,31,153,31,153,30,233,31,216,31,87,31,154,31,4,31,4,30,4,29,183,31,92,31,214,31,164,31,24,31,116,31,73,31,11,31,73,31,163,31,163,30,56,31,119,31,201,31,136,31,168,31,6,31,158,31,158,31,167,31,197,31,96,31,224,31,154,31,26,31,38,31,35,31,234,31,17,31,119,31,94,31,162,31,38,31,46,31,46,30,62,31,110,31,157,31,19,31,166,31,166,30,245,31,187,31,152,31,66,31,211,31,215,31,248,31,104,31,104,30,104,29,162,31,162,30,236,31,146,31,223,31,160,31,5,31,119,31,144,31,144,30,144,29,102,31,218,31,252,31,252,30,252,29,125,31,235,31,236,31,199,31,199,30,194,31,228,31,144,31,144,30,144,29,4,31,84,31,6,31,71,31,36,31,36,30,115,31,115,30,19,31,49,31,49,30,70,31,206,31,23,31,3,31,38,31,98,31,94,31,94,30,197,31,197,30,129,31,197,31,132,31,132,30,238,31,206,31,81,31,140,31,203,31,46,31,57,31,237,31,237,30,152,31,173,31,240,31,55,31,117,31,117,30,181,31,236,31,115,31,115,30,223,31,214,31,103,31,139,31,11,31,234,31,131,31,6,31,178,31,184,31,53,31,76,31,2,31,121,31,17,31,240,31,158,31,95,31,213,31,213,30,182,31,125,31,125,30,43,31,243,31,81,31,164,31,110,31,250,31,186,31,50,31,172,31,25,31,25,30,234,31,117,31,117,30,127,31,127,30,58,31,62,31,13,31,129,31,68,31,13,31,70,31,108,31,27,31,112,31,148,31,148,30,215,31,28,31,174,31,158,31,110,31,186,31,96,31,71,31,71,30,23,31,197,31,181,31,31,31,213,31,213,30,220,31,130,31,15,31,233,31,198,31,222,31,248,31,77,31,77,30,213,31,183,31,80,31,121,31,212,31,147,31,204,31,41,31,100,31,92,31,42,31,63,31,239,31,8,31,8,30,97,31,17,31,17,30,164,31,106,31,45,31,107,31,107,30,107,29,251,31,175,31,151,31,166,31,254,31,9,31,68,31,94,31,98,31,86,31,86,30,40,31,215,31,234,31,176,31,159,31,132,31,132,30,132,29,63,31,243,31,206,31,158,31,248,31,106,31,90,31,74,31,236,31,178,31,216,31,216,30,74,31,74,30,82,31,147,31,172,31,20,31,141,31,38,31,48,31,222,31,48,31,159,31,1,31,4,31,173,31,173,30,49,31,102,31,215,31,37,31,37,30,173,31,197,31,51,31,144,31,144,30,144,29,140,31,120,31,84,31,218,31,204,31,211,31,211,30,67,31,218,31,82,31,82,30,126,31,103,31,220,31,163,31,163,30,50,31,50,30,85,31,152,31,170,31,136,31,67,31,147,31,100,31,100,30,100,29,97,31,176,31,209,31,73,31,141,31,196,31,209,31,21,31,102,31,102,31,2,31,194,31,194,30,194,29,177,31,93,31,93,30,135,31,135,30,55,31,105,31,231,31,58,31,234,31,170,31,165,31,165,30,165,29,165,28,88,31,24,31,80,31,229,31,222,31,127,31,86,31,79,31,124,31,245,31,245,30,194,31,13,31,202,31,42,31,132,31,57,31,76,31,181,31,143,31,135,31,4,31,79,31,12,31,219,31,204,31,177,31,154,31,255,31,255,30,125,31,125,30,215,31,164,31,7,31,119,31,68,31,53,31,24,31,24,30,122,31,57,31,1,31,223,31,223,30,116,31,116,30,80,31,219,31,219,30,128,31,128,30,128,29,189,31,242,31,232,31,145,31,78,31,94,31,94,30,134,31,84,31,60,31,77,31,77,30,21,31,254,31,254,30,116,31,190,31,190,30,56,31,87,31,104,31,239,31,130,31,50,31,50,30,103,31,44,31,116,31,222,31,99,31,233,31,176,31,189,31,207,31,143,31,133,31,137,31,127,31,164,31,55,31,111,31,212,31,76,31,76,30,48,31,48,30,218,31,8,31,8,30,49,31,49,30,49,29,90,31,54,31,173,31,138,31,7,31,7,30,214,31,214,30,87,31,183,31,183,30,81,31,56,31,56,30,56,29,56,28,55,31,222,31,218,31,226,31,150,31,91,31,38,31,29,31,122,31,59,31,82,31,36,31,151,31,76,31,16,31,16,30,16,29,44,31,145,31,145,30,230,31,128,31,63,31,217,31,217,30,253,31,52,31,76,31,97,31,252,31,231,31,102,31,102,30,46,31,223,31,99,31,99,30,185,31,185,30,185,29,80,31,105,31,160,31,242,31,89,31,160,31,160,30,127,31,127,30,96,31,181,31,83,31,9,31,225,31,169,31,194,31,73,31,111,31,241,31,143,31,143,30,227,31,251,31,109,31,177,31,237,31,247,31,198,31,145,31,145,30,70,31,249,31,165,31,232,31,232,30,31,31,31,30,212,31,165,31,165,30,19,31,19,31,19,30,240,31,240,30,37,31,172,31,214,31,48,31,48,31,48,30,230,31,48,31,48,30,177,31,165,31,102,31,60,31,229,31,152,31,235,31,235,30,76,31,174,31,174,30,174,29,174,28,81,31,208,31,129,31,68,31,100,31,23,31,80,31,142,31,142,30,142,29,163,31,163,30,225,31,66,31,155,31,155,30,237,31,237,30,237,29,19,31,12,31,203,31,203,30,32,31,65,31,125,31,125,30,113,31,48,31,48,30,193,31,208,31,5,31,147,31,25,31,226,31,44,31,242,31,165,31,54,31,54,30,54,29,70,31,88,31,90,31,216,31);

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
