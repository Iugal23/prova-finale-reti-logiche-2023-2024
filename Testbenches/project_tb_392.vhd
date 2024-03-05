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

constant SCENARIO_LENGTH : integer := 582;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (33,0,0,0,0,0,249,0,44,0,251,0,64,0,52,0,0,0,98,0,0,0,35,0,0,0,54,0,145,0,37,0,0,0,200,0,243,0,248,0,234,0,187,0,9,0,0,0,148,0,0,0,150,0,0,0,98,0,46,0,249,0,0,0,172,0,0,0,0,0,19,0,243,0,2,0,82,0,152,0,209,0,219,0,110,0,29,0,131,0,122,0,60,0,17,0,92,0,162,0,43,0,0,0,247,0,149,0,71,0,0,0,0,0,0,0,111,0,161,0,146,0,39,0,198,0,72,0,0,0,87,0,18,0,192,0,114,0,59,0,86,0,245,0,53,0,177,0,132,0,255,0,0,0,102,0,18,0,0,0,17,0,214,0,195,0,147,0,0,0,179,0,77,0,184,0,98,0,161,0,102,0,77,0,237,0,170,0,62,0,238,0,230,0,252,0,42,0,17,0,17,0,143,0,170,0,123,0,102,0,0,0,0,0,198,0,132,0,84,0,12,0,181,0,143,0,8,0,184,0,0,0,0,0,0,0,0,0,236,0,63,0,204,0,146,0,137,0,35,0,0,0,0,0,245,0,0,0,229,0,160,0,107,0,197,0,225,0,156,0,101,0,84,0,241,0,157,0,34,0,124,0,183,0,226,0,64,0,11,0,205,0,177,0,89,0,231,0,123,0,131,0,241,0,0,0,61,0,211,0,116,0,237,0,194,0,169,0,239,0,0,0,0,0,0,0,0,0,247,0,150,0,251,0,0,0,1,0,174,0,0,0,23,0,67,0,32,0,192,0,71,0,0,0,0,0,217,0,0,0,245,0,0,0,162,0,0,0,57,0,213,0,29,0,191,0,96,0,225,0,106,0,136,0,13,0,130,0,38,0,242,0,235,0,0,0,183,0,55,0,213,0,178,0,0,0,243,0,236,0,51,0,43,0,244,0,68,0,176,0,71,0,215,0,43,0,28,0,0,0,0,0,0,0,156,0,0,0,0,0,131,0,0,0,0,0,202,0,154,0,147,0,158,0,177,0,162,0,155,0,194,0,47,0,173,0,152,0,60,0,118,0,145,0,26,0,0,0,34,0,53,0,0,0,39,0,90,0,177,0,221,0,38,0,2,0,162,0,1,0,183,0,182,0,231,0,134,0,245,0,0,0,0,0,66,0,29,0,221,0,47,0,194,0,251,0,0,0,0,0,0,0,43,0,0,0,52,0,139,0,17,0,102,0,167,0,0,0,103,0,125,0,139,0,86,0,217,0,100,0,86,0,217,0,0,0,45,0,0,0,215,0,36,0,0,0,47,0,74,0,115,0,240,0,29,0,158,0,122,0,253,0,14,0,87,0,0,0,157,0,0,0,233,0,0,0,218,0,142,0,170,0,127,0,131,0,65,0,239,0,126,0,204,0,10,0,115,0,188,0,74,0,91,0,153,0,158,0,0,0,74,0,22,0,209,0,77,0,178,0,187,0,3,0,188,0,247,0,75,0,47,0,0,0,184,0,0,0,145,0,167,0,151,0,0,0,0,0,104,0,0,0,176,0,0,0,204,0,128,0,132,0,217,0,42,0,195,0,15,0,0,0,34,0,0,0,108,0,0,0,63,0,200,0,29,0,100,0,66,0,0,0,0,0,0,0,26,0,0,0,7,0,123,0,0,0,75,0,0,0,0,0,112,0,122,0,9,0,193,0,120,0,254,0,0,0,218,0,0,0,249,0,214,0,111,0,67,0,168,0,137,0,177,0,63,0,0,0,0,0,14,0,162,0,253,0,241,0,0,0,0,0,232,0,182,0,121,0,135,0,28,0,139,0,79,0,127,0,0,0,188,0,154,0,214,0,152,0,49,0,28,0,62,0,26,0,171,0,14,0,0,0,128,0,242,0,73,0,125,0,135,0,21,0,253,0,121,0,198,0,213,0,243,0,226,0,0,0,14,0,44,0,133,0,113,0,219,0,253,0,0,0,39,0,0,0,49,0,23,0,232,0,180,0,43,0,103,0,0,0,105,0,0,0,0,0,0,0,0,0,0,0,178,0,76,0,230,0,138,0,0,0,158,0,184,0,223,0,2,0,97,0,142,0,197,0,136,0,209,0,86,0,44,0,206,0,0,0,253,0,0,0,126,0,0,0,215,0,0,0,150,0,128,0,0,0,227,0,228,0,39,0,49,0,0,0,189,0,18,0,171,0,90,0,136,0,121,0,75,0,0,0,53,0,174,0,239,0,11,0,212,0,248,0,75,0,145,0,47,0,63,0,79,0,0,0,0,0,97,0,74,0,10,0,130,0,39,0,136,0,77,0,204,0,112,0,200,0,116,0,192,0,118,0,12,0,32,0,9,0,0,0,247,0,250,0,134,0,199,0,56,0,89,0,136,0,0,0,157,0,36,0,162,0,0,0,133,0,48,0,0,0,0,0,42,0,37,0,0,0,0,0,0,0,113,0,34,0,70,0,103,0,91,0,176,0,108,0,246,0,70,0,108,0,134,0,41,0,10,0,208,0,5,0,43,0,39,0,21,0,87,0,215,0,3,0,53,0,0,0,125,0,189,0,220,0,236,0,0,0,187,0,0,0,149,0,0,0,0,0,0,0,58,0,243,0,159,0,12,0,0,0,0,0);
signal scenario_full  : scenario_type := (33,31,33,30,33,29,249,31,44,31,251,31,64,31,52,31,52,30,98,31,98,30,35,31,35,30,54,31,145,31,37,31,37,30,200,31,243,31,248,31,234,31,187,31,9,31,9,30,148,31,148,30,150,31,150,30,98,31,46,31,249,31,249,30,172,31,172,30,172,29,19,31,243,31,2,31,82,31,152,31,209,31,219,31,110,31,29,31,131,31,122,31,60,31,17,31,92,31,162,31,43,31,43,30,247,31,149,31,71,31,71,30,71,29,71,28,111,31,161,31,146,31,39,31,198,31,72,31,72,30,87,31,18,31,192,31,114,31,59,31,86,31,245,31,53,31,177,31,132,31,255,31,255,30,102,31,18,31,18,30,17,31,214,31,195,31,147,31,147,30,179,31,77,31,184,31,98,31,161,31,102,31,77,31,237,31,170,31,62,31,238,31,230,31,252,31,42,31,17,31,17,31,143,31,170,31,123,31,102,31,102,30,102,29,198,31,132,31,84,31,12,31,181,31,143,31,8,31,184,31,184,30,184,29,184,28,184,27,236,31,63,31,204,31,146,31,137,31,35,31,35,30,35,29,245,31,245,30,229,31,160,31,107,31,197,31,225,31,156,31,101,31,84,31,241,31,157,31,34,31,124,31,183,31,226,31,64,31,11,31,205,31,177,31,89,31,231,31,123,31,131,31,241,31,241,30,61,31,211,31,116,31,237,31,194,31,169,31,239,31,239,30,239,29,239,28,239,27,247,31,150,31,251,31,251,30,1,31,174,31,174,30,23,31,67,31,32,31,192,31,71,31,71,30,71,29,217,31,217,30,245,31,245,30,162,31,162,30,57,31,213,31,29,31,191,31,96,31,225,31,106,31,136,31,13,31,130,31,38,31,242,31,235,31,235,30,183,31,55,31,213,31,178,31,178,30,243,31,236,31,51,31,43,31,244,31,68,31,176,31,71,31,215,31,43,31,28,31,28,30,28,29,28,28,156,31,156,30,156,29,131,31,131,30,131,29,202,31,154,31,147,31,158,31,177,31,162,31,155,31,194,31,47,31,173,31,152,31,60,31,118,31,145,31,26,31,26,30,34,31,53,31,53,30,39,31,90,31,177,31,221,31,38,31,2,31,162,31,1,31,183,31,182,31,231,31,134,31,245,31,245,30,245,29,66,31,29,31,221,31,47,31,194,31,251,31,251,30,251,29,251,28,43,31,43,30,52,31,139,31,17,31,102,31,167,31,167,30,103,31,125,31,139,31,86,31,217,31,100,31,86,31,217,31,217,30,45,31,45,30,215,31,36,31,36,30,47,31,74,31,115,31,240,31,29,31,158,31,122,31,253,31,14,31,87,31,87,30,157,31,157,30,233,31,233,30,218,31,142,31,170,31,127,31,131,31,65,31,239,31,126,31,204,31,10,31,115,31,188,31,74,31,91,31,153,31,158,31,158,30,74,31,22,31,209,31,77,31,178,31,187,31,3,31,188,31,247,31,75,31,47,31,47,30,184,31,184,30,145,31,167,31,151,31,151,30,151,29,104,31,104,30,176,31,176,30,204,31,128,31,132,31,217,31,42,31,195,31,15,31,15,30,34,31,34,30,108,31,108,30,63,31,200,31,29,31,100,31,66,31,66,30,66,29,66,28,26,31,26,30,7,31,123,31,123,30,75,31,75,30,75,29,112,31,122,31,9,31,193,31,120,31,254,31,254,30,218,31,218,30,249,31,214,31,111,31,67,31,168,31,137,31,177,31,63,31,63,30,63,29,14,31,162,31,253,31,241,31,241,30,241,29,232,31,182,31,121,31,135,31,28,31,139,31,79,31,127,31,127,30,188,31,154,31,214,31,152,31,49,31,28,31,62,31,26,31,171,31,14,31,14,30,128,31,242,31,73,31,125,31,135,31,21,31,253,31,121,31,198,31,213,31,243,31,226,31,226,30,14,31,44,31,133,31,113,31,219,31,253,31,253,30,39,31,39,30,49,31,23,31,232,31,180,31,43,31,103,31,103,30,105,31,105,30,105,29,105,28,105,27,105,26,178,31,76,31,230,31,138,31,138,30,158,31,184,31,223,31,2,31,97,31,142,31,197,31,136,31,209,31,86,31,44,31,206,31,206,30,253,31,253,30,126,31,126,30,215,31,215,30,150,31,128,31,128,30,227,31,228,31,39,31,49,31,49,30,189,31,18,31,171,31,90,31,136,31,121,31,75,31,75,30,53,31,174,31,239,31,11,31,212,31,248,31,75,31,145,31,47,31,63,31,79,31,79,30,79,29,97,31,74,31,10,31,130,31,39,31,136,31,77,31,204,31,112,31,200,31,116,31,192,31,118,31,12,31,32,31,9,31,9,30,247,31,250,31,134,31,199,31,56,31,89,31,136,31,136,30,157,31,36,31,162,31,162,30,133,31,48,31,48,30,48,29,42,31,37,31,37,30,37,29,37,28,113,31,34,31,70,31,103,31,91,31,176,31,108,31,246,31,70,31,108,31,134,31,41,31,10,31,208,31,5,31,43,31,39,31,21,31,87,31,215,31,3,31,53,31,53,30,125,31,189,31,220,31,236,31,236,30,187,31,187,30,149,31,149,30,149,29,149,28,58,31,243,31,159,31,12,31,12,30,12,29);

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
