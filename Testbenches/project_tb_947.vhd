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

constant SCENARIO_LENGTH : integer := 782;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (4,0,0,0,208,0,0,0,147,0,0,0,196,0,75,0,0,0,220,0,53,0,150,0,0,0,38,0,0,0,156,0,135,0,58,0,143,0,73,0,166,0,83,0,208,0,61,0,82,0,89,0,180,0,25,0,203,0,0,0,47,0,102,0,0,0,0,0,57,0,76,0,203,0,22,0,200,0,155,0,0,0,0,0,147,0,122,0,162,0,53,0,0,0,238,0,0,0,137,0,181,0,200,0,166,0,3,0,73,0,0,0,163,0,99,0,0,0,85,0,220,0,0,0,221,0,16,0,211,0,82,0,102,0,0,0,0,0,105,0,37,0,0,0,167,0,156,0,0,0,248,0,113,0,0,0,128,0,104,0,215,0,102,0,136,0,153,0,58,0,0,0,139,0,179,0,157,0,0,0,51,0,136,0,172,0,77,0,0,0,83,0,183,0,6,0,0,0,175,0,76,0,94,0,19,0,176,0,211,0,140,0,53,0,0,0,15,0,174,0,47,0,94,0,0,0,174,0,127,0,216,0,173,0,0,0,0,0,0,0,164,0,31,0,0,0,22,0,167,0,49,0,75,0,152,0,0,0,203,0,0,0,239,0,189,0,250,0,0,0,251,0,48,0,72,0,133,0,0,0,0,0,232,0,131,0,0,0,109,0,44,0,0,0,39,0,0,0,0,0,0,0,0,0,84,0,121,0,25,0,0,0,30,0,99,0,174,0,156,0,138,0,101,0,154,0,148,0,221,0,0,0,114,0,219,0,19,0,0,0,0,0,42,0,153,0,222,0,28,0,27,0,0,0,0,0,0,0,140,0,120,0,182,0,69,0,16,0,70,0,201,0,137,0,4,0,193,0,0,0,237,0,102,0,0,0,5,0,164,0,0,0,156,0,233,0,150,0,0,0,199,0,145,0,0,0,207,0,0,0,58,0,178,0,133,0,69,0,0,0,13,0,62,0,148,0,110,0,0,0,223,0,0,0,137,0,0,0,37,0,119,0,246,0,0,0,11,0,51,0,0,0,29,0,92,0,108,0,246,0,191,0,237,0,154,0,117,0,27,0,63,0,207,0,127,0,35,0,168,0,167,0,220,0,191,0,100,0,0,0,77,0,119,0,50,0,54,0,194,0,237,0,55,0,160,0,41,0,0,0,40,0,0,0,194,0,102,0,0,0,66,0,23,0,55,0,134,0,0,0,88,0,43,0,194,0,51,0,0,0,160,0,132,0,215,0,66,0,188,0,137,0,177,0,162,0,0,0,38,0,99,0,45,0,0,0,50,0,26,0,54,0,73,0,226,0,182,0,41,0,37,0,126,0,172,0,0,0,80,0,111,0,160,0,57,0,74,0,207,0,206,0,165,0,22,0,244,0,14,0,232,0,26,0,0,0,44,0,137,0,236,0,169,0,195,0,253,0,6,0,70,0,0,0,0,0,0,0,136,0,0,0,214,0,0,0,240,0,238,0,164,0,7,0,185,0,0,0,204,0,121,0,213,0,255,0,0,0,240,0,76,0,103,0,235,0,63,0,198,0,110,0,0,0,146,0,135,0,0,0,0,0,170,0,0,0,57,0,198,0,38,0,93,0,215,0,211,0,28,0,157,0,93,0,176,0,0,0,88,0,21,0,193,0,114,0,30,0,72,0,44,0,0,0,162,0,94,0,219,0,75,0,32,0,26,0,68,0,214,0,160,0,0,0,111,0,62,0,243,0,62,0,245,0,0,0,124,0,122,0,59,0,196,0,215,0,0,0,17,0,50,0,120,0,0,0,24,0,112,0,0,0,97,0,246,0,0,0,0,0,0,0,139,0,36,0,117,0,79,0,0,0,197,0,165,0,222,0,0,0,119,0,158,0,113,0,130,0,0,0,8,0,172,0,67,0,216,0,5,0,224,0,0,0,127,0,0,0,234,0,13,0,0,0,25,0,218,0,0,0,7,0,210,0,0,0,0,0,161,0,48,0,87,0,226,0,0,0,129,0,213,0,0,0,221,0,84,0,17,0,198,0,127,0,40,0,0,0,195,0,140,0,23,0,112,0,21,0,200,0,255,0,37,0,0,0,185,0,1,0,252,0,0,0,77,0,85,0,252,0,155,0,0,0,225,0,105,0,170,0,90,0,21,0,25,0,184,0,33,0,0,0,172,0,149,0,122,0,240,0,205,0,152,0,172,0,139,0,186,0,0,0,159,0,141,0,232,0,0,0,55,0,91,0,108,0,240,0,0,0,70,0,24,0,0,0,0,0,38,0,14,0,0,0,0,0,229,0,166,0,13,0,0,0,44,0,0,0,76,0,53,0,219,0,0,0,0,0,24,0,0,0,42,0,37,0,98,0,129,0,71,0,242,0,249,0,230,0,1,0,182,0,106,0,147,0,0,0,110,0,0,0,159,0,75,0,0,0,11,0,243,0,162,0,68,0,55,0,186,0,155,0,0,0,80,0,0,0,202,0,62,0,48,0,0,0,135,0,197,0,183,0,32,0,213,0,24,0,240,0,248,0,165,0,23,0,195,0,102,0,0,0,0,0,0,0,233,0,131,0,193,0,48,0,200,0,139,0,0,0,30,0,4,0,202,0,0,0,65,0,230,0,244,0,36,0,0,0,0,0,6,0,130,0,0,0,0,0,205,0,0,0,0,0,239,0,178,0,50,0,27,0,0,0,191,0,118,0,120,0,58,0,125,0,148,0,0,0,219,0,237,0,6,0,230,0,183,0,20,0,0,0,118,0,141,0,108,0,112,0,79,0,83,0,73,0,152,0,145,0,0,0,196,0,0,0,57,0,93,0,0,0,228,0,26,0,26,0,6,0,0,0,19,0,151,0,148,0,63,0,5,0,0,0,195,0,0,0,171,0,230,0,0,0,111,0,218,0,251,0,42,0,74,0,93,0,169,0,124,0,219,0,29,0,83,0,161,0,112,0,147,0,140,0,65,0,160,0,89,0,0,0,0,0,22,0,244,0,88,0,74,0,233,0,220,0,254,0,112,0,0,0,122,0,94,0,88,0,137,0,135,0,143,0,0,0,228,0,0,0,118,0,82,0,247,0,143,0,180,0,212,0,0,0,0,0,70,0,20,0,29,0,77,0,178,0,76,0,165,0,143,0,28,0,153,0,64,0,172,0,71,0,56,0,0,0,0,0,18,0,52,0,0,0,114,0,196,0,249,0,137,0,183,0,0,0,0,0,252,0,21,0,212,0,32,0,227,0,0,0,234,0,0,0,144,0,103,0,0,0,142,0,163,0,0,0,0,0,88,0,161,0,175,0,218,0,144,0,135,0,67,0,206,0,28,0,132,0,55,0,0,0,230,0,197,0,0,0,0,0,117,0,42,0,119,0,132,0,204,0,0,0,234,0,0,0,0,0,12,0,215,0,240,0,135,0,72,0,232,0,32,0,0,0,179,0,0,0,131,0,0,0,0,0,166,0,59,0,223,0,37,0,0,0,16,0,237,0,229,0,149,0,134,0,206,0,0,0,0,0,209,0,86,0,165,0,92,0,0,0,236,0,130,0);
signal scenario_full  : scenario_type := (4,31,4,30,208,31,208,30,147,31,147,30,196,31,75,31,75,30,220,31,53,31,150,31,150,30,38,31,38,30,156,31,135,31,58,31,143,31,73,31,166,31,83,31,208,31,61,31,82,31,89,31,180,31,25,31,203,31,203,30,47,31,102,31,102,30,102,29,57,31,76,31,203,31,22,31,200,31,155,31,155,30,155,29,147,31,122,31,162,31,53,31,53,30,238,31,238,30,137,31,181,31,200,31,166,31,3,31,73,31,73,30,163,31,99,31,99,30,85,31,220,31,220,30,221,31,16,31,211,31,82,31,102,31,102,30,102,29,105,31,37,31,37,30,167,31,156,31,156,30,248,31,113,31,113,30,128,31,104,31,215,31,102,31,136,31,153,31,58,31,58,30,139,31,179,31,157,31,157,30,51,31,136,31,172,31,77,31,77,30,83,31,183,31,6,31,6,30,175,31,76,31,94,31,19,31,176,31,211,31,140,31,53,31,53,30,15,31,174,31,47,31,94,31,94,30,174,31,127,31,216,31,173,31,173,30,173,29,173,28,164,31,31,31,31,30,22,31,167,31,49,31,75,31,152,31,152,30,203,31,203,30,239,31,189,31,250,31,250,30,251,31,48,31,72,31,133,31,133,30,133,29,232,31,131,31,131,30,109,31,44,31,44,30,39,31,39,30,39,29,39,28,39,27,84,31,121,31,25,31,25,30,30,31,99,31,174,31,156,31,138,31,101,31,154,31,148,31,221,31,221,30,114,31,219,31,19,31,19,30,19,29,42,31,153,31,222,31,28,31,27,31,27,30,27,29,27,28,140,31,120,31,182,31,69,31,16,31,70,31,201,31,137,31,4,31,193,31,193,30,237,31,102,31,102,30,5,31,164,31,164,30,156,31,233,31,150,31,150,30,199,31,145,31,145,30,207,31,207,30,58,31,178,31,133,31,69,31,69,30,13,31,62,31,148,31,110,31,110,30,223,31,223,30,137,31,137,30,37,31,119,31,246,31,246,30,11,31,51,31,51,30,29,31,92,31,108,31,246,31,191,31,237,31,154,31,117,31,27,31,63,31,207,31,127,31,35,31,168,31,167,31,220,31,191,31,100,31,100,30,77,31,119,31,50,31,54,31,194,31,237,31,55,31,160,31,41,31,41,30,40,31,40,30,194,31,102,31,102,30,66,31,23,31,55,31,134,31,134,30,88,31,43,31,194,31,51,31,51,30,160,31,132,31,215,31,66,31,188,31,137,31,177,31,162,31,162,30,38,31,99,31,45,31,45,30,50,31,26,31,54,31,73,31,226,31,182,31,41,31,37,31,126,31,172,31,172,30,80,31,111,31,160,31,57,31,74,31,207,31,206,31,165,31,22,31,244,31,14,31,232,31,26,31,26,30,44,31,137,31,236,31,169,31,195,31,253,31,6,31,70,31,70,30,70,29,70,28,136,31,136,30,214,31,214,30,240,31,238,31,164,31,7,31,185,31,185,30,204,31,121,31,213,31,255,31,255,30,240,31,76,31,103,31,235,31,63,31,198,31,110,31,110,30,146,31,135,31,135,30,135,29,170,31,170,30,57,31,198,31,38,31,93,31,215,31,211,31,28,31,157,31,93,31,176,31,176,30,88,31,21,31,193,31,114,31,30,31,72,31,44,31,44,30,162,31,94,31,219,31,75,31,32,31,26,31,68,31,214,31,160,31,160,30,111,31,62,31,243,31,62,31,245,31,245,30,124,31,122,31,59,31,196,31,215,31,215,30,17,31,50,31,120,31,120,30,24,31,112,31,112,30,97,31,246,31,246,30,246,29,246,28,139,31,36,31,117,31,79,31,79,30,197,31,165,31,222,31,222,30,119,31,158,31,113,31,130,31,130,30,8,31,172,31,67,31,216,31,5,31,224,31,224,30,127,31,127,30,234,31,13,31,13,30,25,31,218,31,218,30,7,31,210,31,210,30,210,29,161,31,48,31,87,31,226,31,226,30,129,31,213,31,213,30,221,31,84,31,17,31,198,31,127,31,40,31,40,30,195,31,140,31,23,31,112,31,21,31,200,31,255,31,37,31,37,30,185,31,1,31,252,31,252,30,77,31,85,31,252,31,155,31,155,30,225,31,105,31,170,31,90,31,21,31,25,31,184,31,33,31,33,30,172,31,149,31,122,31,240,31,205,31,152,31,172,31,139,31,186,31,186,30,159,31,141,31,232,31,232,30,55,31,91,31,108,31,240,31,240,30,70,31,24,31,24,30,24,29,38,31,14,31,14,30,14,29,229,31,166,31,13,31,13,30,44,31,44,30,76,31,53,31,219,31,219,30,219,29,24,31,24,30,42,31,37,31,98,31,129,31,71,31,242,31,249,31,230,31,1,31,182,31,106,31,147,31,147,30,110,31,110,30,159,31,75,31,75,30,11,31,243,31,162,31,68,31,55,31,186,31,155,31,155,30,80,31,80,30,202,31,62,31,48,31,48,30,135,31,197,31,183,31,32,31,213,31,24,31,240,31,248,31,165,31,23,31,195,31,102,31,102,30,102,29,102,28,233,31,131,31,193,31,48,31,200,31,139,31,139,30,30,31,4,31,202,31,202,30,65,31,230,31,244,31,36,31,36,30,36,29,6,31,130,31,130,30,130,29,205,31,205,30,205,29,239,31,178,31,50,31,27,31,27,30,191,31,118,31,120,31,58,31,125,31,148,31,148,30,219,31,237,31,6,31,230,31,183,31,20,31,20,30,118,31,141,31,108,31,112,31,79,31,83,31,73,31,152,31,145,31,145,30,196,31,196,30,57,31,93,31,93,30,228,31,26,31,26,31,6,31,6,30,19,31,151,31,148,31,63,31,5,31,5,30,195,31,195,30,171,31,230,31,230,30,111,31,218,31,251,31,42,31,74,31,93,31,169,31,124,31,219,31,29,31,83,31,161,31,112,31,147,31,140,31,65,31,160,31,89,31,89,30,89,29,22,31,244,31,88,31,74,31,233,31,220,31,254,31,112,31,112,30,122,31,94,31,88,31,137,31,135,31,143,31,143,30,228,31,228,30,118,31,82,31,247,31,143,31,180,31,212,31,212,30,212,29,70,31,20,31,29,31,77,31,178,31,76,31,165,31,143,31,28,31,153,31,64,31,172,31,71,31,56,31,56,30,56,29,18,31,52,31,52,30,114,31,196,31,249,31,137,31,183,31,183,30,183,29,252,31,21,31,212,31,32,31,227,31,227,30,234,31,234,30,144,31,103,31,103,30,142,31,163,31,163,30,163,29,88,31,161,31,175,31,218,31,144,31,135,31,67,31,206,31,28,31,132,31,55,31,55,30,230,31,197,31,197,30,197,29,117,31,42,31,119,31,132,31,204,31,204,30,234,31,234,30,234,29,12,31,215,31,240,31,135,31,72,31,232,31,32,31,32,30,179,31,179,30,131,31,131,30,131,29,166,31,59,31,223,31,37,31,37,30,16,31,237,31,229,31,149,31,134,31,206,31,206,30,206,29,209,31,86,31,165,31,92,31,92,30,236,31,130,31);

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
