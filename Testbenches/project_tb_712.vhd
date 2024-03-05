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

constant SCENARIO_LENGTH : integer := 611;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (108,0,0,0,239,0,198,0,230,0,0,0,59,0,186,0,20,0,108,0,81,0,3,0,191,0,0,0,169,0,12,0,0,0,0,0,0,0,4,0,213,0,39,0,190,0,4,0,21,0,142,0,98,0,174,0,237,0,27,0,249,0,225,0,32,0,138,0,82,0,177,0,1,0,10,0,199,0,99,0,78,0,115,0,86,0,127,0,15,0,66,0,57,0,79,0,0,0,81,0,122,0,53,0,51,0,75,0,0,0,67,0,0,0,236,0,230,0,212,0,71,0,208,0,106,0,254,0,212,0,72,0,56,0,225,0,155,0,65,0,248,0,0,0,34,0,69,0,171,0,54,0,151,0,198,0,164,0,23,0,129,0,21,0,156,0,63,0,66,0,19,0,0,0,0,0,47,0,146,0,0,0,48,0,128,0,252,0,134,0,40,0,32,0,170,0,212,0,74,0,175,0,83,0,97,0,106,0,79,0,195,0,199,0,217,0,50,0,77,0,243,0,152,0,243,0,235,0,99,0,127,0,242,0,92,0,109,0,196,0,187,0,10,0,103,0,77,0,0,0,57,0,0,0,0,0,54,0,156,0,0,0,153,0,77,0,0,0,143,0,98,0,141,0,80,0,126,0,0,0,196,0,191,0,7,0,152,0,43,0,199,0,14,0,0,0,231,0,0,0,0,0,64,0,70,0,219,0,12,0,52,0,48,0,43,0,160,0,173,0,201,0,183,0,206,0,141,0,239,0,235,0,64,0,0,0,246,0,213,0,94,0,195,0,89,0,0,0,166,0,60,0,0,0,229,0,196,0,131,0,52,0,24,0,18,0,126,0,62,0,184,0,109,0,39,0,77,0,92,0,206,0,0,0,85,0,194,0,186,0,198,0,12,0,0,0,0,0,0,0,55,0,162,0,61,0,195,0,0,0,55,0,199,0,120,0,155,0,142,0,234,0,34,0,150,0,6,0,139,0,21,0,39,0,152,0,0,0,0,0,219,0,50,0,222,0,213,0,0,0,0,0,25,0,0,0,3,0,144,0,32,0,200,0,214,0,249,0,255,0,10,0,51,0,0,0,157,0,0,0,136,0,0,0,0,0,83,0,187,0,0,0,76,0,162,0,37,0,144,0,213,0,0,0,127,0,74,0,0,0,0,0,162,0,0,0,30,0,124,0,167,0,153,0,14,0,0,0,204,0,0,0,0,0,217,0,189,0,237,0,136,0,186,0,186,0,0,0,144,0,94,0,75,0,179,0,140,0,178,0,0,0,0,0,128,0,130,0,116,0,215,0,0,0,255,0,51,0,153,0,145,0,37,0,228,0,90,0,0,0,50,0,223,0,0,0,0,0,182,0,231,0,120,0,0,0,0,0,130,0,226,0,230,0,105,0,239,0,111,0,0,0,0,0,157,0,171,0,0,0,116,0,198,0,216,0,110,0,4,0,88,0,0,0,179,0,85,0,63,0,66,0,76,0,72,0,183,0,143,0,38,0,123,0,11,0,38,0,7,0,127,0,134,0,28,0,126,0,61,0,71,0,239,0,0,0,102,0,21,0,120,0,151,0,0,0,0,0,137,0,96,0,168,0,13,0,148,0,210,0,159,0,0,0,160,0,76,0,0,0,18,0,238,0,47,0,56,0,176,0,29,0,151,0,0,0,213,0,123,0,2,0,123,0,41,0,122,0,192,0,90,0,58,0,93,0,46,0,77,0,28,0,239,0,0,0,147,0,0,0,88,0,204,0,69,0,67,0,0,0,0,0,205,0,62,0,67,0,73,0,86,0,42,0,0,0,0,0,19,0,0,0,0,0,249,0,31,0,101,0,254,0,72,0,210,0,158,0,238,0,199,0,0,0,182,0,10,0,93,0,23,0,200,0,144,0,157,0,0,0,171,0,167,0,146,0,27,0,120,0,19,0,0,0,183,0,251,0,96,0,184,0,153,0,152,0,67,0,153,0,127,0,159,0,137,0,213,0,0,0,188,0,116,0,161,0,113,0,125,0,21,0,171,0,225,0,101,0,0,0,164,0,0,0,119,0,228,0,108,0,191,0,239,0,166,0,177,0,225,0,114,0,72,0,67,0,2,0,18,0,12,0,63,0,235,0,89,0,108,0,36,0,21,0,40,0,62,0,105,0,211,0,42,0,124,0,0,0,0,0,195,0,33,0,0,0,184,0,111,0,228,0,167,0,137,0,0,0,72,0,220,0,0,0,131,0,200,0,47,0,192,0,175,0,0,0,211,0,76,0,0,0,189,0,130,0,197,0,0,0,123,0,22,0,255,0,215,0,199,0,0,0,148,0,22,0,0,0,0,0,180,0,250,0,0,0,205,0,115,0,229,0,139,0,220,0,113,0,4,0,1,0,162,0,92,0,0,0,0,0,44,0,152,0,255,0,187,0,176,0,99,0,120,0,0,0,241,0,244,0,0,0,0,0,112,0,192,0,235,0,198,0,219,0,209,0,0,0,240,0,248,0,124,0,66,0,106,0,0,0,0,0,19,0,184,0,51,0,153,0,212,0,101,0,192,0,234,0,216,0,24,0,0,0,118,0,242,0,20,0,135,0,73,0,191,0,67,0,26,0,144,0,152,0,30,0,60,0,0,0,97,0,250,0,0,0,0,0,213,0,67,0,75,0,94,0,57,0,201,0,0,0,2,0,0,0,172,0,94,0,153,0,125,0,233,0,228,0,249,0,8,0,234,0,0,0,227,0,170,0,82,0,79,0,0,0,0,0,0,0,38,0);
signal scenario_full  : scenario_type := (108,31,108,30,239,31,198,31,230,31,230,30,59,31,186,31,20,31,108,31,81,31,3,31,191,31,191,30,169,31,12,31,12,30,12,29,12,28,4,31,213,31,39,31,190,31,4,31,21,31,142,31,98,31,174,31,237,31,27,31,249,31,225,31,32,31,138,31,82,31,177,31,1,31,10,31,199,31,99,31,78,31,115,31,86,31,127,31,15,31,66,31,57,31,79,31,79,30,81,31,122,31,53,31,51,31,75,31,75,30,67,31,67,30,236,31,230,31,212,31,71,31,208,31,106,31,254,31,212,31,72,31,56,31,225,31,155,31,65,31,248,31,248,30,34,31,69,31,171,31,54,31,151,31,198,31,164,31,23,31,129,31,21,31,156,31,63,31,66,31,19,31,19,30,19,29,47,31,146,31,146,30,48,31,128,31,252,31,134,31,40,31,32,31,170,31,212,31,74,31,175,31,83,31,97,31,106,31,79,31,195,31,199,31,217,31,50,31,77,31,243,31,152,31,243,31,235,31,99,31,127,31,242,31,92,31,109,31,196,31,187,31,10,31,103,31,77,31,77,30,57,31,57,30,57,29,54,31,156,31,156,30,153,31,77,31,77,30,143,31,98,31,141,31,80,31,126,31,126,30,196,31,191,31,7,31,152,31,43,31,199,31,14,31,14,30,231,31,231,30,231,29,64,31,70,31,219,31,12,31,52,31,48,31,43,31,160,31,173,31,201,31,183,31,206,31,141,31,239,31,235,31,64,31,64,30,246,31,213,31,94,31,195,31,89,31,89,30,166,31,60,31,60,30,229,31,196,31,131,31,52,31,24,31,18,31,126,31,62,31,184,31,109,31,39,31,77,31,92,31,206,31,206,30,85,31,194,31,186,31,198,31,12,31,12,30,12,29,12,28,55,31,162,31,61,31,195,31,195,30,55,31,199,31,120,31,155,31,142,31,234,31,34,31,150,31,6,31,139,31,21,31,39,31,152,31,152,30,152,29,219,31,50,31,222,31,213,31,213,30,213,29,25,31,25,30,3,31,144,31,32,31,200,31,214,31,249,31,255,31,10,31,51,31,51,30,157,31,157,30,136,31,136,30,136,29,83,31,187,31,187,30,76,31,162,31,37,31,144,31,213,31,213,30,127,31,74,31,74,30,74,29,162,31,162,30,30,31,124,31,167,31,153,31,14,31,14,30,204,31,204,30,204,29,217,31,189,31,237,31,136,31,186,31,186,31,186,30,144,31,94,31,75,31,179,31,140,31,178,31,178,30,178,29,128,31,130,31,116,31,215,31,215,30,255,31,51,31,153,31,145,31,37,31,228,31,90,31,90,30,50,31,223,31,223,30,223,29,182,31,231,31,120,31,120,30,120,29,130,31,226,31,230,31,105,31,239,31,111,31,111,30,111,29,157,31,171,31,171,30,116,31,198,31,216,31,110,31,4,31,88,31,88,30,179,31,85,31,63,31,66,31,76,31,72,31,183,31,143,31,38,31,123,31,11,31,38,31,7,31,127,31,134,31,28,31,126,31,61,31,71,31,239,31,239,30,102,31,21,31,120,31,151,31,151,30,151,29,137,31,96,31,168,31,13,31,148,31,210,31,159,31,159,30,160,31,76,31,76,30,18,31,238,31,47,31,56,31,176,31,29,31,151,31,151,30,213,31,123,31,2,31,123,31,41,31,122,31,192,31,90,31,58,31,93,31,46,31,77,31,28,31,239,31,239,30,147,31,147,30,88,31,204,31,69,31,67,31,67,30,67,29,205,31,62,31,67,31,73,31,86,31,42,31,42,30,42,29,19,31,19,30,19,29,249,31,31,31,101,31,254,31,72,31,210,31,158,31,238,31,199,31,199,30,182,31,10,31,93,31,23,31,200,31,144,31,157,31,157,30,171,31,167,31,146,31,27,31,120,31,19,31,19,30,183,31,251,31,96,31,184,31,153,31,152,31,67,31,153,31,127,31,159,31,137,31,213,31,213,30,188,31,116,31,161,31,113,31,125,31,21,31,171,31,225,31,101,31,101,30,164,31,164,30,119,31,228,31,108,31,191,31,239,31,166,31,177,31,225,31,114,31,72,31,67,31,2,31,18,31,12,31,63,31,235,31,89,31,108,31,36,31,21,31,40,31,62,31,105,31,211,31,42,31,124,31,124,30,124,29,195,31,33,31,33,30,184,31,111,31,228,31,167,31,137,31,137,30,72,31,220,31,220,30,131,31,200,31,47,31,192,31,175,31,175,30,211,31,76,31,76,30,189,31,130,31,197,31,197,30,123,31,22,31,255,31,215,31,199,31,199,30,148,31,22,31,22,30,22,29,180,31,250,31,250,30,205,31,115,31,229,31,139,31,220,31,113,31,4,31,1,31,162,31,92,31,92,30,92,29,44,31,152,31,255,31,187,31,176,31,99,31,120,31,120,30,241,31,244,31,244,30,244,29,112,31,192,31,235,31,198,31,219,31,209,31,209,30,240,31,248,31,124,31,66,31,106,31,106,30,106,29,19,31,184,31,51,31,153,31,212,31,101,31,192,31,234,31,216,31,24,31,24,30,118,31,242,31,20,31,135,31,73,31,191,31,67,31,26,31,144,31,152,31,30,31,60,31,60,30,97,31,250,31,250,30,250,29,213,31,67,31,75,31,94,31,57,31,201,31,201,30,2,31,2,30,172,31,94,31,153,31,125,31,233,31,228,31,249,31,8,31,234,31,234,30,227,31,170,31,82,31,79,31,79,30,79,29,79,28,38,31);

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
