-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_890 is
end project_tb_890;

architecture project_tb_arch_890 of project_tb_890 is
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

constant SCENARIO_LENGTH : integer := 668;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (135,0,0,0,151,0,18,0,136,0,6,0,6,0,130,0,0,0,126,0,106,0,64,0,0,0,182,0,72,0,58,0,17,0,19,0,95,0,246,0,66,0,0,0,19,0,126,0,99,0,86,0,62,0,113,0,0,0,227,0,247,0,251,0,249,0,234,0,109,0,220,0,103,0,62,0,0,0,0,0,233,0,200,0,46,0,213,0,118,0,3,0,61,0,253,0,127,0,0,0,6,0,132,0,26,0,147,0,150,0,139,0,78,0,217,0,4,0,176,0,139,0,17,0,40,0,102,0,228,0,131,0,22,0,232,0,0,0,71,0,249,0,0,0,176,0,6,0,234,0,135,0,195,0,245,0,0,0,38,0,0,0,0,0,114,0,0,0,146,0,0,0,27,0,125,0,0,0,29,0,128,0,73,0,229,0,116,0,161,0,189,0,246,0,0,0,127,0,28,0,0,0,58,0,59,0,167,0,0,0,135,0,40,0,97,0,0,0,0,0,107,0,207,0,108,0,222,0,234,0,23,0,123,0,0,0,146,0,21,0,240,0,153,0,235,0,201,0,0,0,118,0,121,0,0,0,0,0,226,0,0,0,36,0,77,0,188,0,105,0,67,0,29,0,75,0,234,0,228,0,91,0,183,0,71,0,68,0,198,0,0,0,0,0,90,0,10,0,16,0,174,0,116,0,19,0,72,0,139,0,41,0,57,0,91,0,0,0,248,0,156,0,97,0,0,0,0,0,235,0,0,0,0,0,217,0,76,0,253,0,0,0,195,0,0,0,125,0,219,0,15,0,0,0,0,0,120,0,0,0,190,0,226,0,33,0,35,0,182,0,135,0,0,0,91,0,122,0,207,0,63,0,228,0,91,0,169,0,236,0,0,0,155,0,129,0,0,0,116,0,85,0,0,0,117,0,171,0,216,0,145,0,98,0,32,0,0,0,81,0,0,0,0,0,34,0,123,0,88,0,22,0,223,0,59,0,135,0,116,0,2,0,178,0,0,0,0,0,223,0,39,0,235,0,0,0,130,0,243,0,59,0,55,0,210,0,202,0,26,0,91,0,241,0,0,0,28,0,36,0,111,0,173,0,141,0,137,0,214,0,0,0,163,0,133,0,246,0,214,0,230,0,175,0,116,0,170,0,212,0,229,0,187,0,98,0,12,0,106,0,39,0,23,0,86,0,143,0,0,0,21,0,192,0,61,0,13,0,25,0,184,0,0,0,178,0,35,0,0,0,119,0,32,0,47,0,139,0,0,0,16,0,0,0,0,0,17,0,253,0,69,0,36,0,67,0,106,0,0,0,121,0,88,0,221,0,255,0,29,0,20,0,68,0,224,0,133,0,0,0,110,0,41,0,195,0,101,0,64,0,0,0,87,0,59,0,26,0,54,0,235,0,117,0,63,0,143,0,0,0,201,0,0,0,117,0,0,0,18,0,148,0,180,0,173,0,78,0,205,0,219,0,0,0,238,0,0,0,125,0,254,0,137,0,48,0,0,0,217,0,84,0,160,0,38,0,60,0,81,0,214,0,255,0,148,0,0,0,131,0,46,0,55,0,199,0,154,0,113,0,0,0,88,0,80,0,179,0,189,0,4,0,131,0,21,0,14,0,0,0,100,0,136,0,181,0,203,0,103,0,72,0,33,0,0,0,254,0,226,0,188,0,29,0,0,0,94,0,240,0,66,0,17,0,159,0,46,0,0,0,145,0,101,0,222,0,129,0,214,0,110,0,160,0,0,0,86,0,110,0,6,0,155,0,240,0,0,0,185,0,197,0,37,0,33,0,0,0,173,0,51,0,214,0,69,0,66,0,7,0,0,0,156,0,57,0,25,0,33,0,0,0,171,0,58,0,14,0,0,0,168,0,167,0,48,0,177,0,0,0,113,0,0,0,122,0,106,0,0,0,20,0,47,0,0,0,6,0,42,0,124,0,69,0,122,0,0,0,73,0,0,0,81,0,247,0,192,0,98,0,12,0,115,0,60,0,220,0,100,0,209,0,58,0,234,0,233,0,113,0,0,0,251,0,156,0,150,0,13,0,218,0,0,0,197,0,242,0,244,0,0,0,211,0,21,0,197,0,92,0,132,0,214,0,91,0,0,0,0,0,47,0,74,0,0,0,58,0,102,0,254,0,111,0,9,0,45,0,166,0,66,0,198,0,27,0,162,0,93,0,0,0,89,0,0,0,0,0,186,0,35,0,141,0,218,0,17,0,0,0,3,0,112,0,206,0,178,0,74,0,84,0,113,0,121,0,4,0,18,0,182,0,0,0,0,0,166,0,172,0,19,0,229,0,95,0,0,0,111,0,0,0,132,0,64,0,20,0,244,0,0,0,152,0,168,0,127,0,0,0,254,0,97,0,0,0,21,0,163,0,221,0,177,0,0,0,11,0,236,0,0,0,161,0,178,0,123,0,134,0,72,0,64,0,55,0,11,0,107,0,224,0,117,0,224,0,139,0,104,0,158,0,64,0,99,0,173,0,19,0,14,0,180,0,24,0,196,0,185,0,170,0,0,0,38,0,151,0,39,0,223,0,211,0,147,0,4,0,0,0,64,0,14,0,34,0,44,0,10,0,42,0,91,0,224,0,0,0,190,0,110,0,182,0,99,0,183,0,100,0,226,0,74,0,151,0,171,0,77,0,11,0,129,0,179,0,203,0,0,0,72,0,14,0,153,0,0,0,120,0,1,0,129,0,111,0,153,0,159,0,104,0,21,0,170,0,131,0,2,0,82,0,0,0,181,0,85,0,225,0,45,0,6,0,193,0,140,0,225,0,0,0,205,0,0,0,234,0,166,0,78,0,197,0,48,0,139,0,226,0,70,0,0,0,201,0,34,0,110,0,47,0,0,0,0,0,15,0,24,0,40,0,6,0,36,0,31,0,151,0,95,0,10,0,123,0,42,0,73,0,0,0,78,0,165,0,117,0,198,0,205,0,108,0,4,0,190,0,103,0,129,0,23,0,57,0,174,0,89,0,196,0,172,0,193,0);
signal scenario_full  : scenario_type := (135,31,135,30,151,31,18,31,136,31,6,31,6,31,130,31,130,30,126,31,106,31,64,31,64,30,182,31,72,31,58,31,17,31,19,31,95,31,246,31,66,31,66,30,19,31,126,31,99,31,86,31,62,31,113,31,113,30,227,31,247,31,251,31,249,31,234,31,109,31,220,31,103,31,62,31,62,30,62,29,233,31,200,31,46,31,213,31,118,31,3,31,61,31,253,31,127,31,127,30,6,31,132,31,26,31,147,31,150,31,139,31,78,31,217,31,4,31,176,31,139,31,17,31,40,31,102,31,228,31,131,31,22,31,232,31,232,30,71,31,249,31,249,30,176,31,6,31,234,31,135,31,195,31,245,31,245,30,38,31,38,30,38,29,114,31,114,30,146,31,146,30,27,31,125,31,125,30,29,31,128,31,73,31,229,31,116,31,161,31,189,31,246,31,246,30,127,31,28,31,28,30,58,31,59,31,167,31,167,30,135,31,40,31,97,31,97,30,97,29,107,31,207,31,108,31,222,31,234,31,23,31,123,31,123,30,146,31,21,31,240,31,153,31,235,31,201,31,201,30,118,31,121,31,121,30,121,29,226,31,226,30,36,31,77,31,188,31,105,31,67,31,29,31,75,31,234,31,228,31,91,31,183,31,71,31,68,31,198,31,198,30,198,29,90,31,10,31,16,31,174,31,116,31,19,31,72,31,139,31,41,31,57,31,91,31,91,30,248,31,156,31,97,31,97,30,97,29,235,31,235,30,235,29,217,31,76,31,253,31,253,30,195,31,195,30,125,31,219,31,15,31,15,30,15,29,120,31,120,30,190,31,226,31,33,31,35,31,182,31,135,31,135,30,91,31,122,31,207,31,63,31,228,31,91,31,169,31,236,31,236,30,155,31,129,31,129,30,116,31,85,31,85,30,117,31,171,31,216,31,145,31,98,31,32,31,32,30,81,31,81,30,81,29,34,31,123,31,88,31,22,31,223,31,59,31,135,31,116,31,2,31,178,31,178,30,178,29,223,31,39,31,235,31,235,30,130,31,243,31,59,31,55,31,210,31,202,31,26,31,91,31,241,31,241,30,28,31,36,31,111,31,173,31,141,31,137,31,214,31,214,30,163,31,133,31,246,31,214,31,230,31,175,31,116,31,170,31,212,31,229,31,187,31,98,31,12,31,106,31,39,31,23,31,86,31,143,31,143,30,21,31,192,31,61,31,13,31,25,31,184,31,184,30,178,31,35,31,35,30,119,31,32,31,47,31,139,31,139,30,16,31,16,30,16,29,17,31,253,31,69,31,36,31,67,31,106,31,106,30,121,31,88,31,221,31,255,31,29,31,20,31,68,31,224,31,133,31,133,30,110,31,41,31,195,31,101,31,64,31,64,30,87,31,59,31,26,31,54,31,235,31,117,31,63,31,143,31,143,30,201,31,201,30,117,31,117,30,18,31,148,31,180,31,173,31,78,31,205,31,219,31,219,30,238,31,238,30,125,31,254,31,137,31,48,31,48,30,217,31,84,31,160,31,38,31,60,31,81,31,214,31,255,31,148,31,148,30,131,31,46,31,55,31,199,31,154,31,113,31,113,30,88,31,80,31,179,31,189,31,4,31,131,31,21,31,14,31,14,30,100,31,136,31,181,31,203,31,103,31,72,31,33,31,33,30,254,31,226,31,188,31,29,31,29,30,94,31,240,31,66,31,17,31,159,31,46,31,46,30,145,31,101,31,222,31,129,31,214,31,110,31,160,31,160,30,86,31,110,31,6,31,155,31,240,31,240,30,185,31,197,31,37,31,33,31,33,30,173,31,51,31,214,31,69,31,66,31,7,31,7,30,156,31,57,31,25,31,33,31,33,30,171,31,58,31,14,31,14,30,168,31,167,31,48,31,177,31,177,30,113,31,113,30,122,31,106,31,106,30,20,31,47,31,47,30,6,31,42,31,124,31,69,31,122,31,122,30,73,31,73,30,81,31,247,31,192,31,98,31,12,31,115,31,60,31,220,31,100,31,209,31,58,31,234,31,233,31,113,31,113,30,251,31,156,31,150,31,13,31,218,31,218,30,197,31,242,31,244,31,244,30,211,31,21,31,197,31,92,31,132,31,214,31,91,31,91,30,91,29,47,31,74,31,74,30,58,31,102,31,254,31,111,31,9,31,45,31,166,31,66,31,198,31,27,31,162,31,93,31,93,30,89,31,89,30,89,29,186,31,35,31,141,31,218,31,17,31,17,30,3,31,112,31,206,31,178,31,74,31,84,31,113,31,121,31,4,31,18,31,182,31,182,30,182,29,166,31,172,31,19,31,229,31,95,31,95,30,111,31,111,30,132,31,64,31,20,31,244,31,244,30,152,31,168,31,127,31,127,30,254,31,97,31,97,30,21,31,163,31,221,31,177,31,177,30,11,31,236,31,236,30,161,31,178,31,123,31,134,31,72,31,64,31,55,31,11,31,107,31,224,31,117,31,224,31,139,31,104,31,158,31,64,31,99,31,173,31,19,31,14,31,180,31,24,31,196,31,185,31,170,31,170,30,38,31,151,31,39,31,223,31,211,31,147,31,4,31,4,30,64,31,14,31,34,31,44,31,10,31,42,31,91,31,224,31,224,30,190,31,110,31,182,31,99,31,183,31,100,31,226,31,74,31,151,31,171,31,77,31,11,31,129,31,179,31,203,31,203,30,72,31,14,31,153,31,153,30,120,31,1,31,129,31,111,31,153,31,159,31,104,31,21,31,170,31,131,31,2,31,82,31,82,30,181,31,85,31,225,31,45,31,6,31,193,31,140,31,225,31,225,30,205,31,205,30,234,31,166,31,78,31,197,31,48,31,139,31,226,31,70,31,70,30,201,31,34,31,110,31,47,31,47,30,47,29,15,31,24,31,40,31,6,31,36,31,31,31,151,31,95,31,10,31,123,31,42,31,73,31,73,30,78,31,165,31,117,31,198,31,205,31,108,31,4,31,190,31,103,31,129,31,23,31,57,31,174,31,89,31,196,31,172,31,193,31);

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
