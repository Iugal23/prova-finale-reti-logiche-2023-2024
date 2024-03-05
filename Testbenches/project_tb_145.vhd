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

constant SCENARIO_LENGTH : integer := 851;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (56,0,238,0,17,0,18,0,141,0,0,0,122,0,30,0,0,0,0,0,176,0,15,0,50,0,84,0,65,0,224,0,176,0,137,0,87,0,238,0,0,0,8,0,237,0,119,0,0,0,102,0,157,0,144,0,147,0,0,0,147,0,128,0,255,0,31,0,33,0,212,0,0,0,118,0,223,0,168,0,0,0,219,0,211,0,17,0,120,0,145,0,0,0,0,0,1,0,31,0,139,0,137,0,227,0,60,0,0,0,96,0,232,0,157,0,0,0,0,0,152,0,185,0,0,0,49,0,198,0,98,0,6,0,6,0,0,0,193,0,14,0,70,0,136,0,120,0,59,0,42,0,182,0,222,0,102,0,206,0,0,0,0,0,13,0,97,0,0,0,182,0,234,0,0,0,250,0,239,0,55,0,19,0,14,0,103,0,98,0,108,0,234,0,0,0,134,0,151,0,54,0,24,0,195,0,89,0,25,0,149,0,150,0,0,0,0,0,1,0,9,0,201,0,69,0,0,0,82,0,73,0,6,0,171,0,67,0,126,0,244,0,227,0,245,0,70,0,48,0,67,0,19,0,59,0,0,0,59,0,0,0,218,0,171,0,47,0,252,0,134,0,91,0,0,0,0,0,117,0,181,0,206,0,96,0,124,0,198,0,197,0,122,0,67,0,250,0,0,0,241,0,249,0,180,0,6,0,201,0,0,0,55,0,44,0,27,0,213,0,189,0,24,0,185,0,0,0,130,0,0,0,233,0,0,0,76,0,0,0,227,0,195,0,0,0,130,0,0,0,162,0,90,0,0,0,238,0,0,0,195,0,207,0,230,0,0,0,91,0,21,0,82,0,23,0,234,0,163,0,181,0,189,0,88,0,51,0,239,0,18,0,189,0,239,0,0,0,1,0,194,0,214,0,0,0,151,0,33,0,32,0,130,0,0,0,236,0,0,0,87,0,0,0,9,0,184,0,248,0,234,0,98,0,191,0,0,0,157,0,86,0,0,0,38,0,104,0,86,0,193,0,0,0,224,0,172,0,0,0,38,0,230,0,224,0,138,0,244,0,69,0,141,0,16,0,0,0,0,0,187,0,217,0,84,0,46,0,40,0,0,0,0,0,125,0,45,0,0,0,0,0,182,0,159,0,4,0,43,0,19,0,0,0,131,0,0,0,245,0,17,0,0,0,230,0,93,0,105,0,211,0,0,0,119,0,190,0,202,0,0,0,89,0,0,0,129,0,54,0,89,0,158,0,9,0,168,0,86,0,0,0,57,0,68,0,70,0,59,0,0,0,0,0,196,0,0,0,73,0,222,0,40,0,226,0,236,0,126,0,244,0,7,0,234,0,80,0,206,0,0,0,15,0,217,0,198,0,180,0,0,0,0,0,137,0,49,0,0,0,99,0,217,0,128,0,219,0,0,0,2,0,206,0,0,0,249,0,98,0,1,0,4,0,68,0,99,0,204,0,237,0,121,0,209,0,130,0,239,0,77,0,119,0,42,0,161,0,207,0,197,0,230,0,79,0,49,0,47,0,138,0,86,0,137,0,0,0,71,0,227,0,99,0,0,0,230,0,23,0,35,0,246,0,235,0,91,0,0,0,8,0,0,0,245,0,48,0,198,0,66,0,8,0,89,0,147,0,197,0,127,0,97,0,215,0,210,0,128,0,220,0,164,0,125,0,247,0,232,0,0,0,157,0,205,0,15,0,234,0,118,0,154,0,145,0,84,0,205,0,198,0,16,0,27,0,162,0,120,0,213,0,129,0,33,0,163,0,156,0,98,0,104,0,156,0,138,0,130,0,28,0,219,0,83,0,27,0,117,0,0,0,225,0,239,0,244,0,195,0,72,0,189,0,66,0,77,0,48,0,132,0,225,0,0,0,31,0,78,0,0,0,196,0,1,0,101,0,51,0,218,0,242,0,99,0,0,0,33,0,141,0,218,0,23,0,118,0,174,0,0,0,0,0,139,0,208,0,48,0,109,0,164,0,248,0,60,0,0,0,136,0,0,0,233,0,63,0,175,0,53,0,55,0,0,0,14,0,203,0,182,0,118,0,180,0,27,0,226,0,183,0,142,0,186,0,0,0,228,0,221,0,108,0,113,0,66,0,208,0,52,0,0,0,9,0,0,0,176,0,69,0,193,0,63,0,0,0,0,0,213,0,224,0,139,0,146,0,154,0,0,0,36,0,168,0,0,0,0,0,0,0,87,0,236,0,63,0,33,0,26,0,176,0,14,0,27,0,36,0,59,0,0,0,32,0,107,0,163,0,0,0,0,0,119,0,0,0,25,0,178,0,123,0,92,0,4,0,0,0,231,0,0,0,235,0,251,0,196,0,0,0,176,0,215,0,0,0,0,0,52,0,184,0,42,0,212,0,54,0,88,0,26,0,101,0,185,0,182,0,0,0,123,0,147,0,93,0,129,0,205,0,171,0,0,0,0,0,59,0,124,0,250,0,164,0,138,0,20,0,211,0,108,0,9,0,0,0,235,0,10,0,241,0,253,0,100,0,148,0,40,0,0,0,182,0,0,0,34,0,0,0,16,0,0,0,7,0,217,0,0,0,151,0,126,0,101,0,0,0,0,0,100,0,35,0,0,0,213,0,177,0,0,0,51,0,0,0,214,0,0,0,211,0,0,0,0,0,5,0,171,0,39,0,189,0,42,0,19,0,255,0,55,0,0,0,236,0,102,0,141,0,0,0,106,0,241,0,156,0,61,0,106,0,0,0,103,0,0,0,22,0,0,0,176,0,33,0,13,0,0,0,111,0,0,0,161,0,12,0,0,0,70,0,0,0,96,0,105,0,215,0,169,0,159,0,214,0,0,0,171,0,0,0,94,0,212,0,151,0,172,0,130,0,49,0,133,0,0,0,0,0,245,0,173,0,246,0,122,0,212,0,0,0,195,0,0,0,0,0,158,0,123,0,230,0,17,0,81,0,1,0,222,0,79,0,192,0,227,0,120,0,0,0,135,0,110,0,0,0,251,0,145,0,0,0,124,0,190,0,158,0,0,0,39,0,250,0,178,0,0,0,248,0,110,0,145,0,75,0,0,0,148,0,0,0,0,0,14,0,0,0,143,0,0,0,229,0,182,0,160,0,59,0,0,0,67,0,170,0,0,0,83,0,0,0,60,0,206,0,58,0,236,0,253,0,132,0,38,0,136,0,105,0,21,0,45,0,80,0,16,0,151,0,2,0,152,0,154,0,136,0,0,0,209,0,80,0,0,0,177,0,219,0,68,0,253,0,228,0,106,0,185,0,218,0,237,0,200,0,147,0,77,0,44,0,42,0,58,0,200,0,0,0,244,0,226,0,5,0,122,0,82,0,30,0,134,0,90,0,22,0,151,0,201,0,0,0,113,0,126,0,210,0,62,0,112,0,54,0,64,0,112,0,77,0,177,0,0,0,248,0,177,0,185,0,224,0,27,0,214,0,0,0,0,0,109,0,186,0,0,0,71,0,25,0,73,0,0,0,242,0,0,0,140,0,143,0,159,0,115,0,29,0,19,0,141,0,76,0,0,0,209,0,103,0,31,0,0,0,122,0,0,0,242,0,15,0,21,0,78,0,24,0,105,0,44,0,173,0,112,0,252,0,153,0,18,0,54,0,226,0,233,0,0,0,0,0,109,0,227,0,102,0,28,0,221,0,45,0,147,0,254,0,0,0,161,0,0,0,26,0,0,0,92,0,209,0,104,0,148,0,87,0,211,0,14,0,21,0,0,0,112,0,181,0,0,0,88,0,241,0,189,0,72,0,127,0,36,0,168,0,233,0,0,0,245,0,62,0,0,0,35,0,74,0,0,0,0,0,0,0);
signal scenario_full  : scenario_type := (56,31,238,31,17,31,18,31,141,31,141,30,122,31,30,31,30,30,30,29,176,31,15,31,50,31,84,31,65,31,224,31,176,31,137,31,87,31,238,31,238,30,8,31,237,31,119,31,119,30,102,31,157,31,144,31,147,31,147,30,147,31,128,31,255,31,31,31,33,31,212,31,212,30,118,31,223,31,168,31,168,30,219,31,211,31,17,31,120,31,145,31,145,30,145,29,1,31,31,31,139,31,137,31,227,31,60,31,60,30,96,31,232,31,157,31,157,30,157,29,152,31,185,31,185,30,49,31,198,31,98,31,6,31,6,31,6,30,193,31,14,31,70,31,136,31,120,31,59,31,42,31,182,31,222,31,102,31,206,31,206,30,206,29,13,31,97,31,97,30,182,31,234,31,234,30,250,31,239,31,55,31,19,31,14,31,103,31,98,31,108,31,234,31,234,30,134,31,151,31,54,31,24,31,195,31,89,31,25,31,149,31,150,31,150,30,150,29,1,31,9,31,201,31,69,31,69,30,82,31,73,31,6,31,171,31,67,31,126,31,244,31,227,31,245,31,70,31,48,31,67,31,19,31,59,31,59,30,59,31,59,30,218,31,171,31,47,31,252,31,134,31,91,31,91,30,91,29,117,31,181,31,206,31,96,31,124,31,198,31,197,31,122,31,67,31,250,31,250,30,241,31,249,31,180,31,6,31,201,31,201,30,55,31,44,31,27,31,213,31,189,31,24,31,185,31,185,30,130,31,130,30,233,31,233,30,76,31,76,30,227,31,195,31,195,30,130,31,130,30,162,31,90,31,90,30,238,31,238,30,195,31,207,31,230,31,230,30,91,31,21,31,82,31,23,31,234,31,163,31,181,31,189,31,88,31,51,31,239,31,18,31,189,31,239,31,239,30,1,31,194,31,214,31,214,30,151,31,33,31,32,31,130,31,130,30,236,31,236,30,87,31,87,30,9,31,184,31,248,31,234,31,98,31,191,31,191,30,157,31,86,31,86,30,38,31,104,31,86,31,193,31,193,30,224,31,172,31,172,30,38,31,230,31,224,31,138,31,244,31,69,31,141,31,16,31,16,30,16,29,187,31,217,31,84,31,46,31,40,31,40,30,40,29,125,31,45,31,45,30,45,29,182,31,159,31,4,31,43,31,19,31,19,30,131,31,131,30,245,31,17,31,17,30,230,31,93,31,105,31,211,31,211,30,119,31,190,31,202,31,202,30,89,31,89,30,129,31,54,31,89,31,158,31,9,31,168,31,86,31,86,30,57,31,68,31,70,31,59,31,59,30,59,29,196,31,196,30,73,31,222,31,40,31,226,31,236,31,126,31,244,31,7,31,234,31,80,31,206,31,206,30,15,31,217,31,198,31,180,31,180,30,180,29,137,31,49,31,49,30,99,31,217,31,128,31,219,31,219,30,2,31,206,31,206,30,249,31,98,31,1,31,4,31,68,31,99,31,204,31,237,31,121,31,209,31,130,31,239,31,77,31,119,31,42,31,161,31,207,31,197,31,230,31,79,31,49,31,47,31,138,31,86,31,137,31,137,30,71,31,227,31,99,31,99,30,230,31,23,31,35,31,246,31,235,31,91,31,91,30,8,31,8,30,245,31,48,31,198,31,66,31,8,31,89,31,147,31,197,31,127,31,97,31,215,31,210,31,128,31,220,31,164,31,125,31,247,31,232,31,232,30,157,31,205,31,15,31,234,31,118,31,154,31,145,31,84,31,205,31,198,31,16,31,27,31,162,31,120,31,213,31,129,31,33,31,163,31,156,31,98,31,104,31,156,31,138,31,130,31,28,31,219,31,83,31,27,31,117,31,117,30,225,31,239,31,244,31,195,31,72,31,189,31,66,31,77,31,48,31,132,31,225,31,225,30,31,31,78,31,78,30,196,31,1,31,101,31,51,31,218,31,242,31,99,31,99,30,33,31,141,31,218,31,23,31,118,31,174,31,174,30,174,29,139,31,208,31,48,31,109,31,164,31,248,31,60,31,60,30,136,31,136,30,233,31,63,31,175,31,53,31,55,31,55,30,14,31,203,31,182,31,118,31,180,31,27,31,226,31,183,31,142,31,186,31,186,30,228,31,221,31,108,31,113,31,66,31,208,31,52,31,52,30,9,31,9,30,176,31,69,31,193,31,63,31,63,30,63,29,213,31,224,31,139,31,146,31,154,31,154,30,36,31,168,31,168,30,168,29,168,28,87,31,236,31,63,31,33,31,26,31,176,31,14,31,27,31,36,31,59,31,59,30,32,31,107,31,163,31,163,30,163,29,119,31,119,30,25,31,178,31,123,31,92,31,4,31,4,30,231,31,231,30,235,31,251,31,196,31,196,30,176,31,215,31,215,30,215,29,52,31,184,31,42,31,212,31,54,31,88,31,26,31,101,31,185,31,182,31,182,30,123,31,147,31,93,31,129,31,205,31,171,31,171,30,171,29,59,31,124,31,250,31,164,31,138,31,20,31,211,31,108,31,9,31,9,30,235,31,10,31,241,31,253,31,100,31,148,31,40,31,40,30,182,31,182,30,34,31,34,30,16,31,16,30,7,31,217,31,217,30,151,31,126,31,101,31,101,30,101,29,100,31,35,31,35,30,213,31,177,31,177,30,51,31,51,30,214,31,214,30,211,31,211,30,211,29,5,31,171,31,39,31,189,31,42,31,19,31,255,31,55,31,55,30,236,31,102,31,141,31,141,30,106,31,241,31,156,31,61,31,106,31,106,30,103,31,103,30,22,31,22,30,176,31,33,31,13,31,13,30,111,31,111,30,161,31,12,31,12,30,70,31,70,30,96,31,105,31,215,31,169,31,159,31,214,31,214,30,171,31,171,30,94,31,212,31,151,31,172,31,130,31,49,31,133,31,133,30,133,29,245,31,173,31,246,31,122,31,212,31,212,30,195,31,195,30,195,29,158,31,123,31,230,31,17,31,81,31,1,31,222,31,79,31,192,31,227,31,120,31,120,30,135,31,110,31,110,30,251,31,145,31,145,30,124,31,190,31,158,31,158,30,39,31,250,31,178,31,178,30,248,31,110,31,145,31,75,31,75,30,148,31,148,30,148,29,14,31,14,30,143,31,143,30,229,31,182,31,160,31,59,31,59,30,67,31,170,31,170,30,83,31,83,30,60,31,206,31,58,31,236,31,253,31,132,31,38,31,136,31,105,31,21,31,45,31,80,31,16,31,151,31,2,31,152,31,154,31,136,31,136,30,209,31,80,31,80,30,177,31,219,31,68,31,253,31,228,31,106,31,185,31,218,31,237,31,200,31,147,31,77,31,44,31,42,31,58,31,200,31,200,30,244,31,226,31,5,31,122,31,82,31,30,31,134,31,90,31,22,31,151,31,201,31,201,30,113,31,126,31,210,31,62,31,112,31,54,31,64,31,112,31,77,31,177,31,177,30,248,31,177,31,185,31,224,31,27,31,214,31,214,30,214,29,109,31,186,31,186,30,71,31,25,31,73,31,73,30,242,31,242,30,140,31,143,31,159,31,115,31,29,31,19,31,141,31,76,31,76,30,209,31,103,31,31,31,31,30,122,31,122,30,242,31,15,31,21,31,78,31,24,31,105,31,44,31,173,31,112,31,252,31,153,31,18,31,54,31,226,31,233,31,233,30,233,29,109,31,227,31,102,31,28,31,221,31,45,31,147,31,254,31,254,30,161,31,161,30,26,31,26,30,92,31,209,31,104,31,148,31,87,31,211,31,14,31,21,31,21,30,112,31,181,31,181,30,88,31,241,31,189,31,72,31,127,31,36,31,168,31,233,31,233,30,245,31,62,31,62,30,35,31,74,31,74,30,74,29,74,28);

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
