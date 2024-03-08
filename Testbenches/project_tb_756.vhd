-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_756 is
end project_tb_756;

architecture project_tb_arch_756 of project_tb_756 is
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

constant SCENARIO_LENGTH : integer := 806;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (252,0,135,0,72,0,0,0,39,0,119,0,172,0,79,0,0,0,226,0,32,0,252,0,109,0,0,0,37,0,0,0,0,0,242,0,162,0,247,0,212,0,224,0,117,0,58,0,237,0,228,0,143,0,230,0,130,0,103,0,221,0,97,0,252,0,66,0,211,0,0,0,78,0,4,0,78,0,0,0,58,0,27,0,243,0,234,0,0,0,189,0,63,0,143,0,70,0,28,0,27,0,0,0,0,0,55,0,152,0,0,0,132,0,0,0,180,0,71,0,221,0,165,0,198,0,0,0,0,0,184,0,173,0,0,0,10,0,200,0,142,0,39,0,17,0,180,0,252,0,154,0,69,0,181,0,0,0,170,0,59,0,77,0,241,0,201,0,20,0,109,0,112,0,83,0,242,0,0,0,151,0,0,0,144,0,0,0,94,0,146,0,240,0,65,0,173,0,101,0,143,0,33,0,235,0,101,0,0,0,240,0,167,0,197,0,139,0,0,0,0,0,10,0,149,0,78,0,0,0,0,0,112,0,0,0,182,0,72,0,0,0,142,0,203,0,158,0,0,0,0,0,104,0,186,0,41,0,207,0,230,0,27,0,204,0,2,0,33,0,197,0,192,0,189,0,38,0,0,0,155,0,177,0,252,0,153,0,252,0,126,0,142,0,0,0,237,0,0,0,93,0,226,0,108,0,254,0,111,0,85,0,158,0,0,0,194,0,0,0,16,0,136,0,244,0,25,0,13,0,11,0,0,0,26,0,76,0,144,0,33,0,151,0,0,0,55,0,107,0,98,0,16,0,61,0,138,0,0,0,228,0,131,0,24,0,169,0,56,0,195,0,96,0,210,0,155,0,103,0,121,0,245,0,0,0,11,0,133,0,158,0,111,0,162,0,80,0,62,0,0,0,0,0,37,0,0,0,1,0,0,0,253,0,1,0,94,0,169,0,253,0,16,0,72,0,236,0,5,0,183,0,243,0,0,0,62,0,0,0,198,0,180,0,106,0,0,0,0,0,0,0,118,0,200,0,195,0,65,0,0,0,0,0,61,0,167,0,127,0,40,0,193,0,0,0,0,0,24,0,111,0,168,0,199,0,34,0,25,0,164,0,99,0,0,0,27,0,0,0,144,0,71,0,96,0,210,0,112,0,0,0,231,0,232,0,0,0,0,0,128,0,0,0,126,0,136,0,2,0,70,0,58,0,59,0,0,0,198,0,26,0,181,0,0,0,199,0,47,0,18,0,0,0,107,0,252,0,0,0,183,0,126,0,198,0,205,0,143,0,187,0,117,0,106,0,231,0,72,0,0,0,178,0,221,0,255,0,55,0,36,0,0,0,48,0,186,0,0,0,161,0,177,0,104,0,195,0,223,0,116,0,206,0,5,0,185,0,16,0,100,0,215,0,216,0,191,0,10,0,223,0,157,0,0,0,227,0,0,0,70,0,161,0,248,0,23,0,0,0,234,0,7,0,220,0,0,0,19,0,24,0,118,0,0,0,78,0,86,0,3,0,119,0,162,0,29,0,119,0,17,0,0,0,234,0,84,0,62,0,250,0,241,0,0,0,252,0,183,0,194,0,100,0,251,0,26,0,130,0,234,0,44,0,223,0,74,0,0,0,204,0,146,0,189,0,68,0,193,0,183,0,95,0,0,0,40,0,76,0,200,0,207,0,119,0,47,0,46,0,241,0,29,0,0,0,34,0,62,0,248,0,97,0,27,0,194,0,241,0,0,0,0,0,0,0,140,0,211,0,0,0,191,0,167,0,118,0,239,0,117,0,119,0,10,0,31,0,114,0,147,0,0,0,176,0,82,0,0,0,5,0,37,0,0,0,60,0,0,0,0,0,122,0,146,0,94,0,0,0,249,0,181,0,0,0,0,0,11,0,96,0,0,0,211,0,202,0,192,0,192,0,0,0,44,0,0,0,0,0,0,0,43,0,117,0,119,0,49,0,176,0,197,0,199,0,53,0,238,0,81,0,173,0,122,0,26,0,167,0,96,0,103,0,255,0,8,0,187,0,0,0,0,0,48,0,0,0,146,0,119,0,243,0,17,0,170,0,132,0,101,0,143,0,97,0,77,0,113,0,77,0,45,0,69,0,0,0,120,0,242,0,78,0,222,0,28,0,242,0,37,0,98,0,188,0,236,0,78,0,213,0,0,0,0,0,141,0,175,0,128,0,157,0,251,0,0,0,160,0,137,0,234,0,173,0,0,0,114,0,0,0,182,0,80,0,161,0,46,0,176,0,80,0,221,0,147,0,131,0,78,0,132,0,0,0,24,0,19,0,185,0,194,0,21,0,14,0,242,0,102,0,152,0,135,0,2,0,0,0,164,0,0,0,125,0,227,0,201,0,124,0,225,0,136,0,0,0,203,0,55,0,123,0,103,0,0,0,217,0,28,0,226,0,0,0,214,0,58,0,35,0,155,0,25,0,121,0,90,0,151,0,0,0,26,0,0,0,0,0,213,0,226,0,106,0,63,0,0,0,0,0,0,0,0,0,243,0,145,0,42,0,35,0,102,0,0,0,140,0,229,0,132,0,84,0,48,0,58,0,0,0,0,0,153,0,162,0,244,0,50,0,146,0,169,0,178,0,178,0,173,0,51,0,154,0,162,0,0,0,0,0,67,0,253,0,184,0,0,0,113,0,26,0,98,0,166,0,143,0,0,0,211,0,178,0,0,0,228,0,75,0,186,0,75,0,30,0,2,0,131,0,78,0,133,0,0,0,1,0,68,0,68,0,251,0,170,0,254,0,238,0,71,0,113,0,168,0,76,0,55,0,0,0,111,0,0,0,163,0,0,0,5,0,2,0,0,0,129,0,112,0,39,0,133,0,196,0,0,0,0,0,0,0,236,0,223,0,152,0,253,0,220,0,199,0,107,0,96,0,95,0,223,0,141,0,4,0,84,0,0,0,240,0,104,0,7,0,18,0,4,0,61,0,68,0,185,0,0,0,77,0,174,0,3,0,112,0,26,0,207,0,72,0,91,0,72,0,167,0,222,0,0,0,239,0,177,0,134,0,76,0,35,0,0,0,144,0,245,0,189,0,235,0,1,0,0,0,101,0,67,0,254,0,161,0,0,0,0,0,91,0,65,0,0,0,10,0,0,0,82,0,0,0,204,0,64,0,0,0,3,0,114,0,102,0,250,0,110,0,96,0,0,0,211,0,95,0,167,0,0,0,0,0,0,0,197,0,2,0,157,0,0,0,0,0,2,0,189,0,214,0,252,0,83,0,179,0,157,0,172,0,0,0,213,0,142,0,202,0,13,0,230,0,231,0,7,0,70,0,80,0,230,0,1,0,111,0,104,0,55,0,0,0,194,0,247,0,103,0,53,0,116,0,0,0,139,0,90,0,0,0,168,0,96,0,76,0,235,0,0,0,0,0,0,0,85,0,213,0,0,0,251,0,35,0,0,0,147,0,43,0,112,0,44,0,162,0,173,0,132,0,234,0,243,0,153,0,128,0,0,0,238,0,23,0,206,0,86,0,80,0,141,0,35,0,167,0,138,0,237,0,31,0,124,0,32,0,40,0,0,0,65,0,127,0,111,0,220,0,26,0,0,0,243,0,49,0,51,0,0,0,0,0,61,0,48,0,248,0,142,0);
signal scenario_full  : scenario_type := (252,31,135,31,72,31,72,30,39,31,119,31,172,31,79,31,79,30,226,31,32,31,252,31,109,31,109,30,37,31,37,30,37,29,242,31,162,31,247,31,212,31,224,31,117,31,58,31,237,31,228,31,143,31,230,31,130,31,103,31,221,31,97,31,252,31,66,31,211,31,211,30,78,31,4,31,78,31,78,30,58,31,27,31,243,31,234,31,234,30,189,31,63,31,143,31,70,31,28,31,27,31,27,30,27,29,55,31,152,31,152,30,132,31,132,30,180,31,71,31,221,31,165,31,198,31,198,30,198,29,184,31,173,31,173,30,10,31,200,31,142,31,39,31,17,31,180,31,252,31,154,31,69,31,181,31,181,30,170,31,59,31,77,31,241,31,201,31,20,31,109,31,112,31,83,31,242,31,242,30,151,31,151,30,144,31,144,30,94,31,146,31,240,31,65,31,173,31,101,31,143,31,33,31,235,31,101,31,101,30,240,31,167,31,197,31,139,31,139,30,139,29,10,31,149,31,78,31,78,30,78,29,112,31,112,30,182,31,72,31,72,30,142,31,203,31,158,31,158,30,158,29,104,31,186,31,41,31,207,31,230,31,27,31,204,31,2,31,33,31,197,31,192,31,189,31,38,31,38,30,155,31,177,31,252,31,153,31,252,31,126,31,142,31,142,30,237,31,237,30,93,31,226,31,108,31,254,31,111,31,85,31,158,31,158,30,194,31,194,30,16,31,136,31,244,31,25,31,13,31,11,31,11,30,26,31,76,31,144,31,33,31,151,31,151,30,55,31,107,31,98,31,16,31,61,31,138,31,138,30,228,31,131,31,24,31,169,31,56,31,195,31,96,31,210,31,155,31,103,31,121,31,245,31,245,30,11,31,133,31,158,31,111,31,162,31,80,31,62,31,62,30,62,29,37,31,37,30,1,31,1,30,253,31,1,31,94,31,169,31,253,31,16,31,72,31,236,31,5,31,183,31,243,31,243,30,62,31,62,30,198,31,180,31,106,31,106,30,106,29,106,28,118,31,200,31,195,31,65,31,65,30,65,29,61,31,167,31,127,31,40,31,193,31,193,30,193,29,24,31,111,31,168,31,199,31,34,31,25,31,164,31,99,31,99,30,27,31,27,30,144,31,71,31,96,31,210,31,112,31,112,30,231,31,232,31,232,30,232,29,128,31,128,30,126,31,136,31,2,31,70,31,58,31,59,31,59,30,198,31,26,31,181,31,181,30,199,31,47,31,18,31,18,30,107,31,252,31,252,30,183,31,126,31,198,31,205,31,143,31,187,31,117,31,106,31,231,31,72,31,72,30,178,31,221,31,255,31,55,31,36,31,36,30,48,31,186,31,186,30,161,31,177,31,104,31,195,31,223,31,116,31,206,31,5,31,185,31,16,31,100,31,215,31,216,31,191,31,10,31,223,31,157,31,157,30,227,31,227,30,70,31,161,31,248,31,23,31,23,30,234,31,7,31,220,31,220,30,19,31,24,31,118,31,118,30,78,31,86,31,3,31,119,31,162,31,29,31,119,31,17,31,17,30,234,31,84,31,62,31,250,31,241,31,241,30,252,31,183,31,194,31,100,31,251,31,26,31,130,31,234,31,44,31,223,31,74,31,74,30,204,31,146,31,189,31,68,31,193,31,183,31,95,31,95,30,40,31,76,31,200,31,207,31,119,31,47,31,46,31,241,31,29,31,29,30,34,31,62,31,248,31,97,31,27,31,194,31,241,31,241,30,241,29,241,28,140,31,211,31,211,30,191,31,167,31,118,31,239,31,117,31,119,31,10,31,31,31,114,31,147,31,147,30,176,31,82,31,82,30,5,31,37,31,37,30,60,31,60,30,60,29,122,31,146,31,94,31,94,30,249,31,181,31,181,30,181,29,11,31,96,31,96,30,211,31,202,31,192,31,192,31,192,30,44,31,44,30,44,29,44,28,43,31,117,31,119,31,49,31,176,31,197,31,199,31,53,31,238,31,81,31,173,31,122,31,26,31,167,31,96,31,103,31,255,31,8,31,187,31,187,30,187,29,48,31,48,30,146,31,119,31,243,31,17,31,170,31,132,31,101,31,143,31,97,31,77,31,113,31,77,31,45,31,69,31,69,30,120,31,242,31,78,31,222,31,28,31,242,31,37,31,98,31,188,31,236,31,78,31,213,31,213,30,213,29,141,31,175,31,128,31,157,31,251,31,251,30,160,31,137,31,234,31,173,31,173,30,114,31,114,30,182,31,80,31,161,31,46,31,176,31,80,31,221,31,147,31,131,31,78,31,132,31,132,30,24,31,19,31,185,31,194,31,21,31,14,31,242,31,102,31,152,31,135,31,2,31,2,30,164,31,164,30,125,31,227,31,201,31,124,31,225,31,136,31,136,30,203,31,55,31,123,31,103,31,103,30,217,31,28,31,226,31,226,30,214,31,58,31,35,31,155,31,25,31,121,31,90,31,151,31,151,30,26,31,26,30,26,29,213,31,226,31,106,31,63,31,63,30,63,29,63,28,63,27,243,31,145,31,42,31,35,31,102,31,102,30,140,31,229,31,132,31,84,31,48,31,58,31,58,30,58,29,153,31,162,31,244,31,50,31,146,31,169,31,178,31,178,31,173,31,51,31,154,31,162,31,162,30,162,29,67,31,253,31,184,31,184,30,113,31,26,31,98,31,166,31,143,31,143,30,211,31,178,31,178,30,228,31,75,31,186,31,75,31,30,31,2,31,131,31,78,31,133,31,133,30,1,31,68,31,68,31,251,31,170,31,254,31,238,31,71,31,113,31,168,31,76,31,55,31,55,30,111,31,111,30,163,31,163,30,5,31,2,31,2,30,129,31,112,31,39,31,133,31,196,31,196,30,196,29,196,28,236,31,223,31,152,31,253,31,220,31,199,31,107,31,96,31,95,31,223,31,141,31,4,31,84,31,84,30,240,31,104,31,7,31,18,31,4,31,61,31,68,31,185,31,185,30,77,31,174,31,3,31,112,31,26,31,207,31,72,31,91,31,72,31,167,31,222,31,222,30,239,31,177,31,134,31,76,31,35,31,35,30,144,31,245,31,189,31,235,31,1,31,1,30,101,31,67,31,254,31,161,31,161,30,161,29,91,31,65,31,65,30,10,31,10,30,82,31,82,30,204,31,64,31,64,30,3,31,114,31,102,31,250,31,110,31,96,31,96,30,211,31,95,31,167,31,167,30,167,29,167,28,197,31,2,31,157,31,157,30,157,29,2,31,189,31,214,31,252,31,83,31,179,31,157,31,172,31,172,30,213,31,142,31,202,31,13,31,230,31,231,31,7,31,70,31,80,31,230,31,1,31,111,31,104,31,55,31,55,30,194,31,247,31,103,31,53,31,116,31,116,30,139,31,90,31,90,30,168,31,96,31,76,31,235,31,235,30,235,29,235,28,85,31,213,31,213,30,251,31,35,31,35,30,147,31,43,31,112,31,44,31,162,31,173,31,132,31,234,31,243,31,153,31,128,31,128,30,238,31,23,31,206,31,86,31,80,31,141,31,35,31,167,31,138,31,237,31,31,31,124,31,32,31,40,31,40,30,65,31,127,31,111,31,220,31,26,31,26,30,243,31,49,31,51,31,51,30,51,29,61,31,48,31,248,31,142,31);

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
