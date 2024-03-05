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

constant SCENARIO_LENGTH : integer := 757;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,214,0,182,0,90,0,242,0,133,0,50,0,94,0,251,0,240,0,136,0,109,0,13,0,224,0,167,0,111,0,36,0,165,0,177,0,243,0,155,0,0,0,91,0,93,0,167,0,98,0,224,0,0,0,149,0,121,0,0,0,92,0,0,0,155,0,174,0,52,0,227,0,0,0,80,0,24,0,222,0,80,0,0,0,158,0,56,0,24,0,38,0,75,0,52,0,0,0,249,0,175,0,183,0,214,0,228,0,0,0,0,0,130,0,20,0,179,0,0,0,0,0,0,0,244,0,168,0,216,0,169,0,0,0,217,0,223,0,170,0,107,0,0,0,179,0,136,0,182,0,39,0,196,0,143,0,108,0,49,0,164,0,14,0,0,0,183,0,0,0,217,0,250,0,0,0,37,0,0,0,0,0,0,0,242,0,39,0,113,0,87,0,109,0,181,0,113,0,25,0,241,0,247,0,130,0,54,0,213,0,180,0,252,0,0,0,16,0,0,0,0,0,0,0,70,0,73,0,46,0,2,0,0,0,217,0,178,0,62,0,0,0,201,0,47,0,0,0,91,0,172,0,224,0,122,0,217,0,0,0,193,0,181,0,230,0,23,0,182,0,171,0,114,0,0,0,0,0,102,0,174,0,207,0,0,0,226,0,247,0,166,0,213,0,0,0,197,0,89,0,212,0,0,0,0,0,87,0,68,0,188,0,119,0,197,0,14,0,21,0,0,0,32,0,155,0,240,0,94,0,46,0,0,0,178,0,226,0,220,0,87,0,250,0,12,0,0,0,164,0,144,0,49,0,222,0,0,0,246,0,253,0,224,0,115,0,53,0,54,0,56,0,0,0,237,0,14,0,200,0,34,0,39,0,0,0,217,0,246,0,181,0,205,0,253,0,66,0,0,0,23,0,68,0,33,0,231,0,0,0,45,0,213,0,87,0,106,0,166,0,81,0,114,0,248,0,90,0,123,0,170,0,66,0,198,0,0,0,177,0,82,0,236,0,128,0,65,0,181,0,35,0,163,0,19,0,159,0,235,0,0,0,152,0,60,0,35,0,236,0,240,0,219,0,65,0,110,0,68,0,0,0,229,0,130,0,138,0,62,0,147,0,202,0,0,0,34,0,202,0,229,0,0,0,125,0,30,0,0,0,60,0,0,0,25,0,3,0,120,0,111,0,134,0,60,0,0,0,2,0,26,0,24,0,0,0,49,0,54,0,0,0,222,0,211,0,0,0,149,0,12,0,123,0,168,0,167,0,142,0,0,0,54,0,171,0,2,0,109,0,0,0,0,0,200,0,250,0,150,0,72,0,114,0,169,0,20,0,252,0,172,0,0,0,0,0,16,0,22,0,247,0,85,0,164,0,104,0,229,0,189,0,29,0,177,0,122,0,0,0,16,0,115,0,175,0,78,0,25,0,126,0,86,0,157,0,0,0,202,0,0,0,0,0,0,0,0,0,212,0,0,0,52,0,58,0,130,0,56,0,0,0,0,0,226,0,0,0,0,0,147,0,212,0,78,0,134,0,0,0,0,0,78,0,91,0,0,0,156,0,130,0,49,0,160,0,192,0,0,0,169,0,254,0,243,0,69,0,43,0,0,0,213,0,0,0,12,0,238,0,211,0,74,0,111,0,46,0,104,0,145,0,126,0,124,0,255,0,118,0,217,0,243,0,248,0,183,0,189,0,148,0,92,0,68,0,136,0,0,0,68,0,61,0,71,0,0,0,0,0,180,0,61,0,223,0,161,0,159,0,84,0,9,0,219,0,160,0,0,0,21,0,0,0,64,0,94,0,86,0,1,0,175,0,125,0,131,0,0,0,108,0,143,0,0,0,0,0,75,0,0,0,110,0,225,0,190,0,196,0,187,0,188,0,158,0,188,0,241,0,68,0,180,0,31,0,46,0,105,0,132,0,228,0,91,0,0,0,241,0,0,0,0,0,69,0,0,0,127,0,8,0,173,0,214,0,0,0,77,0,0,0,74,0,190,0,116,0,51,0,185,0,183,0,45,0,52,0,61,0,157,0,150,0,16,0,95,0,105,0,200,0,237,0,110,0,123,0,0,0,0,0,108,0,169,0,114,0,21,0,246,0,241,0,84,0,0,0,32,0,105,0,226,0,171,0,218,0,243,0,28,0,195,0,189,0,148,0,42,0,203,0,103,0,207,0,17,0,82,0,155,0,0,0,100,0,89,0,50,0,210,0,16,0,0,0,181,0,54,0,107,0,74,0,190,0,123,0,0,0,0,0,65,0,152,0,220,0,0,0,172,0,102,0,152,0,120,0,183,0,114,0,50,0,78,0,188,0,94,0,0,0,102,0,30,0,163,0,42,0,122,0,39,0,20,0,62,0,0,0,0,0,211,0,120,0,0,0,133,0,44,0,0,0,0,0,35,0,81,0,44,0,0,0,223,0,84,0,118,0,97,0,219,0,222,0,0,0,131,0,33,0,255,0,14,0,49,0,112,0,255,0,178,0,0,0,45,0,13,0,4,0,24,0,60,0,0,0,141,0,0,0,0,0,230,0,0,0,109,0,243,0,42,0,99,0,182,0,162,0,128,0,0,0,67,0,136,0,214,0,140,0,0,0,128,0,95,0,238,0,0,0,0,0,0,0,56,0,69,0,207,0,43,0,110,0,230,0,149,0,53,0,21,0,0,0,108,0,247,0,211,0,140,0,150,0,224,0,151,0,0,0,250,0,200,0,217,0,171,0,214,0,113,0,61,0,247,0,201,0,123,0,0,0,0,0,188,0,0,0,105,0,6,0,0,0,182,0,240,0,233,0,0,0,192,0,117,0,190,0,80,0,21,0,31,0,133,0,130,0,242,0,190,0,0,0,0,0,63,0,72,0,187,0,129,0,199,0,0,0,48,0,0,0,87,0,5,0,0,0,0,0,231,0,0,0,17,0,236,0,105,0,174,0,0,0,5,0,0,0,135,0,0,0,222,0,110,0,0,0,69,0,233,0,33,0,215,0,53,0,171,0,219,0,85,0,180,0,17,0,100,0,0,0,37,0,220,0,120,0,0,0,130,0,0,0,157,0,170,0,178,0,0,0,71,0,190,0,152,0,0,0,153,0,69,0,0,0,8,0,103,0,70,0,0,0,0,0,70,0,197,0,212,0,29,0,58,0,122,0,0,0,230,0,223,0,0,0,105,0,7,0,11,0,68,0,214,0,34,0,98,0,79,0,111,0,0,0,89,0,185,0,14,0,0,0,83,0,196,0,89,0,65,0,71,0,0,0,48,0,153,0,86,0,100,0,0,0,11,0,110,0,0,0,248,0,117,0,234,0,0,0,134,0,79,0,204,0,223,0,0,0,0,0,0,0,155,0,0,0,149,0,155,0,35,0,28,0,237,0,79,0,204,0,164,0,236,0,32,0,60,0);
signal scenario_full  : scenario_type := (0,0,214,31,182,31,90,31,242,31,133,31,50,31,94,31,251,31,240,31,136,31,109,31,13,31,224,31,167,31,111,31,36,31,165,31,177,31,243,31,155,31,155,30,91,31,93,31,167,31,98,31,224,31,224,30,149,31,121,31,121,30,92,31,92,30,155,31,174,31,52,31,227,31,227,30,80,31,24,31,222,31,80,31,80,30,158,31,56,31,24,31,38,31,75,31,52,31,52,30,249,31,175,31,183,31,214,31,228,31,228,30,228,29,130,31,20,31,179,31,179,30,179,29,179,28,244,31,168,31,216,31,169,31,169,30,217,31,223,31,170,31,107,31,107,30,179,31,136,31,182,31,39,31,196,31,143,31,108,31,49,31,164,31,14,31,14,30,183,31,183,30,217,31,250,31,250,30,37,31,37,30,37,29,37,28,242,31,39,31,113,31,87,31,109,31,181,31,113,31,25,31,241,31,247,31,130,31,54,31,213,31,180,31,252,31,252,30,16,31,16,30,16,29,16,28,70,31,73,31,46,31,2,31,2,30,217,31,178,31,62,31,62,30,201,31,47,31,47,30,91,31,172,31,224,31,122,31,217,31,217,30,193,31,181,31,230,31,23,31,182,31,171,31,114,31,114,30,114,29,102,31,174,31,207,31,207,30,226,31,247,31,166,31,213,31,213,30,197,31,89,31,212,31,212,30,212,29,87,31,68,31,188,31,119,31,197,31,14,31,21,31,21,30,32,31,155,31,240,31,94,31,46,31,46,30,178,31,226,31,220,31,87,31,250,31,12,31,12,30,164,31,144,31,49,31,222,31,222,30,246,31,253,31,224,31,115,31,53,31,54,31,56,31,56,30,237,31,14,31,200,31,34,31,39,31,39,30,217,31,246,31,181,31,205,31,253,31,66,31,66,30,23,31,68,31,33,31,231,31,231,30,45,31,213,31,87,31,106,31,166,31,81,31,114,31,248,31,90,31,123,31,170,31,66,31,198,31,198,30,177,31,82,31,236,31,128,31,65,31,181,31,35,31,163,31,19,31,159,31,235,31,235,30,152,31,60,31,35,31,236,31,240,31,219,31,65,31,110,31,68,31,68,30,229,31,130,31,138,31,62,31,147,31,202,31,202,30,34,31,202,31,229,31,229,30,125,31,30,31,30,30,60,31,60,30,25,31,3,31,120,31,111,31,134,31,60,31,60,30,2,31,26,31,24,31,24,30,49,31,54,31,54,30,222,31,211,31,211,30,149,31,12,31,123,31,168,31,167,31,142,31,142,30,54,31,171,31,2,31,109,31,109,30,109,29,200,31,250,31,150,31,72,31,114,31,169,31,20,31,252,31,172,31,172,30,172,29,16,31,22,31,247,31,85,31,164,31,104,31,229,31,189,31,29,31,177,31,122,31,122,30,16,31,115,31,175,31,78,31,25,31,126,31,86,31,157,31,157,30,202,31,202,30,202,29,202,28,202,27,212,31,212,30,52,31,58,31,130,31,56,31,56,30,56,29,226,31,226,30,226,29,147,31,212,31,78,31,134,31,134,30,134,29,78,31,91,31,91,30,156,31,130,31,49,31,160,31,192,31,192,30,169,31,254,31,243,31,69,31,43,31,43,30,213,31,213,30,12,31,238,31,211,31,74,31,111,31,46,31,104,31,145,31,126,31,124,31,255,31,118,31,217,31,243,31,248,31,183,31,189,31,148,31,92,31,68,31,136,31,136,30,68,31,61,31,71,31,71,30,71,29,180,31,61,31,223,31,161,31,159,31,84,31,9,31,219,31,160,31,160,30,21,31,21,30,64,31,94,31,86,31,1,31,175,31,125,31,131,31,131,30,108,31,143,31,143,30,143,29,75,31,75,30,110,31,225,31,190,31,196,31,187,31,188,31,158,31,188,31,241,31,68,31,180,31,31,31,46,31,105,31,132,31,228,31,91,31,91,30,241,31,241,30,241,29,69,31,69,30,127,31,8,31,173,31,214,31,214,30,77,31,77,30,74,31,190,31,116,31,51,31,185,31,183,31,45,31,52,31,61,31,157,31,150,31,16,31,95,31,105,31,200,31,237,31,110,31,123,31,123,30,123,29,108,31,169,31,114,31,21,31,246,31,241,31,84,31,84,30,32,31,105,31,226,31,171,31,218,31,243,31,28,31,195,31,189,31,148,31,42,31,203,31,103,31,207,31,17,31,82,31,155,31,155,30,100,31,89,31,50,31,210,31,16,31,16,30,181,31,54,31,107,31,74,31,190,31,123,31,123,30,123,29,65,31,152,31,220,31,220,30,172,31,102,31,152,31,120,31,183,31,114,31,50,31,78,31,188,31,94,31,94,30,102,31,30,31,163,31,42,31,122,31,39,31,20,31,62,31,62,30,62,29,211,31,120,31,120,30,133,31,44,31,44,30,44,29,35,31,81,31,44,31,44,30,223,31,84,31,118,31,97,31,219,31,222,31,222,30,131,31,33,31,255,31,14,31,49,31,112,31,255,31,178,31,178,30,45,31,13,31,4,31,24,31,60,31,60,30,141,31,141,30,141,29,230,31,230,30,109,31,243,31,42,31,99,31,182,31,162,31,128,31,128,30,67,31,136,31,214,31,140,31,140,30,128,31,95,31,238,31,238,30,238,29,238,28,56,31,69,31,207,31,43,31,110,31,230,31,149,31,53,31,21,31,21,30,108,31,247,31,211,31,140,31,150,31,224,31,151,31,151,30,250,31,200,31,217,31,171,31,214,31,113,31,61,31,247,31,201,31,123,31,123,30,123,29,188,31,188,30,105,31,6,31,6,30,182,31,240,31,233,31,233,30,192,31,117,31,190,31,80,31,21,31,31,31,133,31,130,31,242,31,190,31,190,30,190,29,63,31,72,31,187,31,129,31,199,31,199,30,48,31,48,30,87,31,5,31,5,30,5,29,231,31,231,30,17,31,236,31,105,31,174,31,174,30,5,31,5,30,135,31,135,30,222,31,110,31,110,30,69,31,233,31,33,31,215,31,53,31,171,31,219,31,85,31,180,31,17,31,100,31,100,30,37,31,220,31,120,31,120,30,130,31,130,30,157,31,170,31,178,31,178,30,71,31,190,31,152,31,152,30,153,31,69,31,69,30,8,31,103,31,70,31,70,30,70,29,70,31,197,31,212,31,29,31,58,31,122,31,122,30,230,31,223,31,223,30,105,31,7,31,11,31,68,31,214,31,34,31,98,31,79,31,111,31,111,30,89,31,185,31,14,31,14,30,83,31,196,31,89,31,65,31,71,31,71,30,48,31,153,31,86,31,100,31,100,30,11,31,110,31,110,30,248,31,117,31,234,31,234,30,134,31,79,31,204,31,223,31,223,30,223,29,223,28,155,31,155,30,149,31,155,31,35,31,28,31,237,31,79,31,204,31,164,31,236,31,32,31,60,31);

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
