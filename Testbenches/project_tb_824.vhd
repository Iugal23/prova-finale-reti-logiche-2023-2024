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

constant SCENARIO_LENGTH : integer := 871;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (68,0,180,0,166,0,88,0,80,0,0,0,12,0,0,0,126,0,157,0,248,0,0,0,219,0,108,0,0,0,237,0,202,0,182,0,17,0,0,0,51,0,133,0,63,0,162,0,253,0,88,0,24,0,137,0,141,0,213,0,218,0,224,0,239,0,149,0,0,0,0,0,210,0,0,0,0,0,180,0,223,0,91,0,156,0,255,0,141,0,192,0,118,0,67,0,0,0,37,0,15,0,208,0,27,0,0,0,71,0,62,0,112,0,0,0,254,0,116,0,15,0,0,0,116,0,51,0,0,0,199,0,232,0,229,0,10,0,194,0,174,0,125,0,185,0,155,0,0,0,111,0,253,0,162,0,123,0,0,0,57,0,0,0,0,0,194,0,221,0,243,0,0,0,168,0,137,0,0,0,202,0,171,0,233,0,0,0,0,0,0,0,112,0,1,0,200,0,91,0,3,0,26,0,250,0,188,0,19,0,177,0,225,0,235,0,156,0,55,0,170,0,195,0,59,0,0,0,30,0,75,0,0,0,63,0,58,0,181,0,188,0,0,0,158,0,116,0,215,0,200,0,161,0,0,0,42,0,152,0,102,0,107,0,58,0,189,0,192,0,0,0,13,0,46,0,26,0,50,0,140,0,1,0,0,0,200,0,8,0,0,0,103,0,3,0,62,0,198,0,111,0,216,0,123,0,59,0,105,0,180,0,131,0,239,0,0,0,122,0,0,0,252,0,17,0,242,0,80,0,55,0,166,0,142,0,0,0,169,0,199,0,140,0,0,0,0,0,199,0,0,0,197,0,13,0,0,0,0,0,0,0,245,0,24,0,0,0,75,0,241,0,0,0,126,0,82,0,189,0,30,0,230,0,0,0,109,0,163,0,7,0,49,0,214,0,147,0,182,0,70,0,129,0,182,0,0,0,80,0,106,0,40,0,80,0,0,0,0,0,201,0,138,0,114,0,0,0,105,0,140,0,163,0,73,0,0,0,224,0,44,0,159,0,194,0,5,0,223,0,0,0,135,0,170,0,148,0,62,0,133,0,80,0,153,0,39,0,219,0,147,0,208,0,184,0,0,0,89,0,9,0,107,0,0,0,135,0,244,0,66,0,233,0,56,0,10,0,52,0,240,0,47,0,11,0,0,0,84,0,0,0,90,0,130,0,222,0,206,0,234,0,0,0,245,0,92,0,92,0,23,0,9,0,231,0,0,0,165,0,59,0,155,0,241,0,25,0,59,0,191,0,169,0,254,0,0,0,195,0,196,0,0,0,0,0,205,0,0,0,46,0,26,0,207,0,131,0,149,0,169,0,0,0,245,0,212,0,239,0,0,0,235,0,0,0,0,0,193,0,0,0,0,0,0,0,151,0,5,0,64,0,91,0,133,0,240,0,99,0,94,0,34,0,0,0,74,0,190,0,237,0,121,0,97,0,41,0,49,0,0,0,0,0,219,0,236,0,0,0,67,0,176,0,224,0,112,0,57,0,135,0,167,0,232,0,24,0,205,0,75,0,167,0,18,0,243,0,0,0,0,0,255,0,179,0,54,0,121,0,165,0,0,0,9,0,89,0,72,0,207,0,241,0,0,0,16,0,35,0,123,0,131,0,218,0,212,0,173,0,218,0,180,0,17,0,133,0,90,0,194,0,214,0,254,0,251,0,195,0,108,0,183,0,225,0,82,0,211,0,0,0,149,0,0,0,172,0,199,0,96,0,106,0,39,0,190,0,85,0,0,0,0,0,119,0,170,0,106,0,0,0,237,0,153,0,64,0,207,0,151,0,110,0,0,0,155,0,175,0,178,0,221,0,2,0,91,0,0,0,88,0,206,0,82,0,0,0,115,0,4,0,175,0,30,0,49,0,6,0,0,0,228,0,0,0,116,0,103,0,223,0,167,0,187,0,177,0,21,0,29,0,181,0,92,0,150,0,213,0,132,0,160,0,102,0,0,0,8,0,0,0,165,0,0,0,100,0,0,0,0,0,165,0,244,0,242,0,36,0,111,0,115,0,0,0,0,0,190,0,213,0,102,0,0,0,65,0,89,0,76,0,188,0,232,0,98,0,20,0,248,0,107,0,0,0,77,0,25,0,78,0,241,0,0,0,0,0,0,0,5,0,83,0,85,0,138,0,0,0,0,0,189,0,0,0,0,0,229,0,40,0,0,0,33,0,24,0,157,0,208,0,215,0,80,0,252,0,115,0,0,0,236,0,105,0,240,0,0,0,194,0,62,0,98,0,214,0,0,0,98,0,100,0,183,0,211,0,0,0,241,0,173,0,110,0,211,0,93,0,65,0,45,0,49,0,90,0,59,0,115,0,0,0,0,0,181,0,118,0,12,0,142,0,199,0,18,0,245,0,46,0,123,0,248,0,100,0,200,0,144,0,0,0,15,0,202,0,190,0,176,0,202,0,0,0,49,0,0,0,204,0,224,0,199,0,183,0,218,0,96,0,196,0,154,0,44,0,72,0,137,0,0,0,196,0,238,0,232,0,146,0,22,0,253,0,185,0,88,0,237,0,19,0,0,0,53,0,128,0,253,0,254,0,62,0,208,0,154,0,161,0,0,0,233,0,246,0,197,0,120,0,22,0,0,0,133,0,89,0,0,0,235,0,204,0,25,0,105,0,127,0,174,0,107,0,228,0,0,0,28,0,187,0,143,0,97,0,107,0,65,0,92,0,142,0,164,0,150,0,178,0,0,0,111,0,99,0,21,0,0,0,43,0,20,0,247,0,221,0,152,0,132,0,122,0,13,0,0,0,62,0,100,0,185,0,41,0,244,0,163,0,0,0,0,0,101,0,165,0,130,0,0,0,0,0,65,0,51,0,128,0,229,0,160,0,141,0,187,0,245,0,155,0,83,0,216,0,0,0,198,0,50,0,131,0,0,0,43,0,245,0,68,0,244,0,0,0,148,0,28,0,83,0,8,0,252,0,201,0,176,0,194,0,5,0,0,0,201,0,241,0,153,0,50,0,3,0,28,0,0,0,224,0,51,0,0,0,0,0,48,0,12,0,47,0,65,0,0,0,0,0,48,0,4,0,0,0,137,0,0,0,255,0,0,0,66,0,134,0,48,0,0,0,33,0,196,0,97,0,81,0,52,0,24,0,210,0,0,0,28,0,92,0,0,0,148,0,26,0,154,0,158,0,141,0,112,0,95,0,0,0,250,0,0,0,0,0,222,0,168,0,231,0,207,0,177,0,0,0,0,0,99,0,248,0,134,0,0,0,177,0,0,0,213,0,167,0,218,0,53,0,19,0,97,0,0,0,218,0,102,0,0,0,57,0,173,0,0,0,201,0,0,0,86,0,44,0,41,0,41,0,30,0,197,0,8,0,0,0,153,0,93,0,6,0,134,0,148,0,222,0,0,0,138,0,174,0,183,0,60,0,210,0,196,0,251,0,153,0,0,0,177,0,15,0,252,0,0,0,141,0,0,0,220,0,149,0,192,0,145,0,21,0,94,0,253,0,0,0,69,0,129,0,0,0,143,0,50,0,191,0,0,0,34,0,0,0,158,0,10,0,39,0,0,0,255,0,108,0,9,0,209,0,17,0,20,0,91,0,196,0,23,0,60,0,255,0,167,0,45,0,62,0,194,0,57,0,109,0,111,0,244,0,136,0,251,0,32,0,240,0,0,0,215,0,204,0,188,0,0,0,147,0,0,0,53,0,0,0,52,0,143,0,94,0,39,0,87,0,218,0,131,0,0,0,14,0,98,0,194,0,111,0,205,0,0,0,35,0,233,0,137,0,199,0,124,0,64,0,247,0,87,0,0,0,102,0,243,0,47,0,188,0,193,0,152,0,112,0,0,0,0,0,0,0,235,0,210,0,208,0,253,0,227,0,146,0,68,0,0,0,192,0,21,0,248,0,44,0,233,0,177,0,0,0,146,0,38,0,217,0);
signal scenario_full  : scenario_type := (68,31,180,31,166,31,88,31,80,31,80,30,12,31,12,30,126,31,157,31,248,31,248,30,219,31,108,31,108,30,237,31,202,31,182,31,17,31,17,30,51,31,133,31,63,31,162,31,253,31,88,31,24,31,137,31,141,31,213,31,218,31,224,31,239,31,149,31,149,30,149,29,210,31,210,30,210,29,180,31,223,31,91,31,156,31,255,31,141,31,192,31,118,31,67,31,67,30,37,31,15,31,208,31,27,31,27,30,71,31,62,31,112,31,112,30,254,31,116,31,15,31,15,30,116,31,51,31,51,30,199,31,232,31,229,31,10,31,194,31,174,31,125,31,185,31,155,31,155,30,111,31,253,31,162,31,123,31,123,30,57,31,57,30,57,29,194,31,221,31,243,31,243,30,168,31,137,31,137,30,202,31,171,31,233,31,233,30,233,29,233,28,112,31,1,31,200,31,91,31,3,31,26,31,250,31,188,31,19,31,177,31,225,31,235,31,156,31,55,31,170,31,195,31,59,31,59,30,30,31,75,31,75,30,63,31,58,31,181,31,188,31,188,30,158,31,116,31,215,31,200,31,161,31,161,30,42,31,152,31,102,31,107,31,58,31,189,31,192,31,192,30,13,31,46,31,26,31,50,31,140,31,1,31,1,30,200,31,8,31,8,30,103,31,3,31,62,31,198,31,111,31,216,31,123,31,59,31,105,31,180,31,131,31,239,31,239,30,122,31,122,30,252,31,17,31,242,31,80,31,55,31,166,31,142,31,142,30,169,31,199,31,140,31,140,30,140,29,199,31,199,30,197,31,13,31,13,30,13,29,13,28,245,31,24,31,24,30,75,31,241,31,241,30,126,31,82,31,189,31,30,31,230,31,230,30,109,31,163,31,7,31,49,31,214,31,147,31,182,31,70,31,129,31,182,31,182,30,80,31,106,31,40,31,80,31,80,30,80,29,201,31,138,31,114,31,114,30,105,31,140,31,163,31,73,31,73,30,224,31,44,31,159,31,194,31,5,31,223,31,223,30,135,31,170,31,148,31,62,31,133,31,80,31,153,31,39,31,219,31,147,31,208,31,184,31,184,30,89,31,9,31,107,31,107,30,135,31,244,31,66,31,233,31,56,31,10,31,52,31,240,31,47,31,11,31,11,30,84,31,84,30,90,31,130,31,222,31,206,31,234,31,234,30,245,31,92,31,92,31,23,31,9,31,231,31,231,30,165,31,59,31,155,31,241,31,25,31,59,31,191,31,169,31,254,31,254,30,195,31,196,31,196,30,196,29,205,31,205,30,46,31,26,31,207,31,131,31,149,31,169,31,169,30,245,31,212,31,239,31,239,30,235,31,235,30,235,29,193,31,193,30,193,29,193,28,151,31,5,31,64,31,91,31,133,31,240,31,99,31,94,31,34,31,34,30,74,31,190,31,237,31,121,31,97,31,41,31,49,31,49,30,49,29,219,31,236,31,236,30,67,31,176,31,224,31,112,31,57,31,135,31,167,31,232,31,24,31,205,31,75,31,167,31,18,31,243,31,243,30,243,29,255,31,179,31,54,31,121,31,165,31,165,30,9,31,89,31,72,31,207,31,241,31,241,30,16,31,35,31,123,31,131,31,218,31,212,31,173,31,218,31,180,31,17,31,133,31,90,31,194,31,214,31,254,31,251,31,195,31,108,31,183,31,225,31,82,31,211,31,211,30,149,31,149,30,172,31,199,31,96,31,106,31,39,31,190,31,85,31,85,30,85,29,119,31,170,31,106,31,106,30,237,31,153,31,64,31,207,31,151,31,110,31,110,30,155,31,175,31,178,31,221,31,2,31,91,31,91,30,88,31,206,31,82,31,82,30,115,31,4,31,175,31,30,31,49,31,6,31,6,30,228,31,228,30,116,31,103,31,223,31,167,31,187,31,177,31,21,31,29,31,181,31,92,31,150,31,213,31,132,31,160,31,102,31,102,30,8,31,8,30,165,31,165,30,100,31,100,30,100,29,165,31,244,31,242,31,36,31,111,31,115,31,115,30,115,29,190,31,213,31,102,31,102,30,65,31,89,31,76,31,188,31,232,31,98,31,20,31,248,31,107,31,107,30,77,31,25,31,78,31,241,31,241,30,241,29,241,28,5,31,83,31,85,31,138,31,138,30,138,29,189,31,189,30,189,29,229,31,40,31,40,30,33,31,24,31,157,31,208,31,215,31,80,31,252,31,115,31,115,30,236,31,105,31,240,31,240,30,194,31,62,31,98,31,214,31,214,30,98,31,100,31,183,31,211,31,211,30,241,31,173,31,110,31,211,31,93,31,65,31,45,31,49,31,90,31,59,31,115,31,115,30,115,29,181,31,118,31,12,31,142,31,199,31,18,31,245,31,46,31,123,31,248,31,100,31,200,31,144,31,144,30,15,31,202,31,190,31,176,31,202,31,202,30,49,31,49,30,204,31,224,31,199,31,183,31,218,31,96,31,196,31,154,31,44,31,72,31,137,31,137,30,196,31,238,31,232,31,146,31,22,31,253,31,185,31,88,31,237,31,19,31,19,30,53,31,128,31,253,31,254,31,62,31,208,31,154,31,161,31,161,30,233,31,246,31,197,31,120,31,22,31,22,30,133,31,89,31,89,30,235,31,204,31,25,31,105,31,127,31,174,31,107,31,228,31,228,30,28,31,187,31,143,31,97,31,107,31,65,31,92,31,142,31,164,31,150,31,178,31,178,30,111,31,99,31,21,31,21,30,43,31,20,31,247,31,221,31,152,31,132,31,122,31,13,31,13,30,62,31,100,31,185,31,41,31,244,31,163,31,163,30,163,29,101,31,165,31,130,31,130,30,130,29,65,31,51,31,128,31,229,31,160,31,141,31,187,31,245,31,155,31,83,31,216,31,216,30,198,31,50,31,131,31,131,30,43,31,245,31,68,31,244,31,244,30,148,31,28,31,83,31,8,31,252,31,201,31,176,31,194,31,5,31,5,30,201,31,241,31,153,31,50,31,3,31,28,31,28,30,224,31,51,31,51,30,51,29,48,31,12,31,47,31,65,31,65,30,65,29,48,31,4,31,4,30,137,31,137,30,255,31,255,30,66,31,134,31,48,31,48,30,33,31,196,31,97,31,81,31,52,31,24,31,210,31,210,30,28,31,92,31,92,30,148,31,26,31,154,31,158,31,141,31,112,31,95,31,95,30,250,31,250,30,250,29,222,31,168,31,231,31,207,31,177,31,177,30,177,29,99,31,248,31,134,31,134,30,177,31,177,30,213,31,167,31,218,31,53,31,19,31,97,31,97,30,218,31,102,31,102,30,57,31,173,31,173,30,201,31,201,30,86,31,44,31,41,31,41,31,30,31,197,31,8,31,8,30,153,31,93,31,6,31,134,31,148,31,222,31,222,30,138,31,174,31,183,31,60,31,210,31,196,31,251,31,153,31,153,30,177,31,15,31,252,31,252,30,141,31,141,30,220,31,149,31,192,31,145,31,21,31,94,31,253,31,253,30,69,31,129,31,129,30,143,31,50,31,191,31,191,30,34,31,34,30,158,31,10,31,39,31,39,30,255,31,108,31,9,31,209,31,17,31,20,31,91,31,196,31,23,31,60,31,255,31,167,31,45,31,62,31,194,31,57,31,109,31,111,31,244,31,136,31,251,31,32,31,240,31,240,30,215,31,204,31,188,31,188,30,147,31,147,30,53,31,53,30,52,31,143,31,94,31,39,31,87,31,218,31,131,31,131,30,14,31,98,31,194,31,111,31,205,31,205,30,35,31,233,31,137,31,199,31,124,31,64,31,247,31,87,31,87,30,102,31,243,31,47,31,188,31,193,31,152,31,112,31,112,30,112,29,112,28,235,31,210,31,208,31,253,31,227,31,146,31,68,31,68,30,192,31,21,31,248,31,44,31,233,31,177,31,177,30,146,31,38,31,217,31);

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
