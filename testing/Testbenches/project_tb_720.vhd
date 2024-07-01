-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_720 is
end project_tb_720;

architecture project_tb_arch_720 of project_tb_720 is
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

constant SCENARIO_LENGTH : integer := 575;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (6,0,189,0,226,0,123,0,0,0,0,0,174,0,0,0,11,0,98,0,37,0,31,0,206,0,8,0,0,0,184,0,222,0,117,0,108,0,79,0,140,0,47,0,211,0,105,0,237,0,203,0,87,0,60,0,143,0,165,0,201,0,140,0,53,0,245,0,243,0,201,0,62,0,252,0,65,0,88,0,0,0,3,0,0,0,0,0,104,0,150,0,41,0,173,0,93,0,0,0,0,0,214,0,68,0,34,0,215,0,210,0,137,0,129,0,85,0,158,0,61,0,235,0,177,0,0,0,21,0,252,0,47,0,0,0,25,0,238,0,66,0,0,0,0,0,23,0,0,0,169,0,253,0,169,0,209,0,137,0,205,0,212,0,44,0,73,0,0,0,214,0,0,0,229,0,0,0,201,0,0,0,130,0,6,0,225,0,0,0,20,0,0,0,250,0,0,0,110,0,249,0,145,0,169,0,112,0,117,0,234,0,12,0,110,0,230,0,159,0,34,0,165,0,189,0,203,0,41,0,176,0,178,0,162,0,181,0,246,0,75,0,182,0,113,0,180,0,217,0,0,0,206,0,152,0,188,0,220,0,0,0,0,0,0,0,116,0,0,0,108,0,128,0,0,0,0,0,0,0,238,0,163,0,0,0,0,0,0,0,177,0,0,0,0,0,169,0,134,0,213,0,245,0,61,0,153,0,95,0,52,0,2,0,132,0,128,0,0,0,199,0,87,0,4,0,90,0,27,0,63,0,0,0,17,0,215,0,131,0,115,0,168,0,12,0,8,0,162,0,241,0,58,0,156,0,116,0,199,0,134,0,0,0,24,0,217,0,205,0,202,0,202,0,213,0,93,0,188,0,193,0,0,0,68,0,0,0,0,0,69,0,9,0,70,0,5,0,114,0,0,0,62,0,144,0,104,0,170,0,19,0,105,0,119,0,148,0,156,0,175,0,231,0,121,0,148,0,0,0,0,0,0,0,229,0,0,0,36,0,0,0,122,0,0,0,151,0,104,0,59,0,209,0,0,0,38,0,229,0,133,0,158,0,127,0,251,0,207,0,43,0,252,0,239,0,0,0,146,0,55,0,0,0,116,0,128,0,5,0,186,0,228,0,75,0,197,0,0,0,0,0,20,0,186,0,182,0,18,0,82,0,0,0,124,0,119,0,191,0,0,0,106,0,211,0,96,0,6,0,176,0,65,0,73,0,130,0,185,0,0,0,10,0,231,0,130,0,134,0,87,0,0,0,0,0,180,0,7,0,96,0,115,0,2,0,255,0,145,0,106,0,177,0,110,0,189,0,74,0,218,0,0,0,169,0,179,0,136,0,174,0,36,0,159,0,130,0,0,0,96,0,140,0,8,0,90,0,62,0,0,0,0,0,0,0,120,0,2,0,187,0,71,0,246,0,0,0,116,0,0,0,25,0,49,0,163,0,105,0,0,0,245,0,152,0,111,0,1,0,239,0,205,0,62,0,5,0,152,0,50,0,219,0,2,0,0,0,249,0,62,0,0,0,221,0,81,0,88,0,24,0,0,0,73,0,111,0,71,0,0,0,136,0,62,0,140,0,135,0,76,0,195,0,174,0,233,0,233,0,0,0,0,0,207,0,26,0,215,0,85,0,46,0,122,0,180,0,57,0,247,0,49,0,0,0,225,0,0,0,209,0,0,0,103,0,222,0,224,0,58,0,54,0,210,0,0,0,154,0,94,0,240,0,139,0,0,0,229,0,57,0,253,0,167,0,28,0,103,0,201,0,157,0,18,0,108,0,74,0,153,0,0,0,195,0,154,0,0,0,130,0,27,0,67,0,186,0,152,0,0,0,0,0,92,0,0,0,77,0,139,0,196,0,187,0,236,0,0,0,161,0,122,0,27,0,151,0,140,0,48,0,63,0,189,0,234,0,116,0,123,0,212,0,249,0,0,0,41,0,100,0,103,0,189,0,0,0,0,0,253,0,86,0,0,0,233,0,0,0,221,0,240,0,73,0,53,0,0,0,46,0,157,0,91,0,206,0,229,0,79,0,0,0,0,0,0,0,66,0,3,0,101,0,83,0,0,0,235,0,202,0,6,0,4,0,166,0,0,0,0,0,144,0,22,0,171,0,0,0,253,0,0,0,200,0,147,0,158,0,150,0,247,0,75,0,143,0,207,0,141,0,96,0,85,0,0,0,76,0,15,0,0,0,81,0,0,0,76,0,208,0,55,0,182,0,230,0,0,0,0,0,219,0,0,0,156,0,123,0,199,0,0,0,121,0,117,0,47,0,0,0,0,0,33,0,213,0,148,0,0,0,97,0,214,0,223,0,166,0,160,0,0,0,43,0,188,0,148,0,190,0,177,0,106,0,253,0,196,0,0,0,144,0,163,0,140,0,0,0,169,0,31,0,52,0,88,0,50,0,244,0,79,0,0,0,31,0,24,0,133,0,0,0,76,0,155,0,124,0,0,0,55,0,0,0,183,0,86,0,184,0,153,0,232,0,164,0,0,0,233,0,19,0,19,0,0,0,58,0,234,0,202,0,167,0,0,0,139,0,0,0,25,0,0,0,148,0,252,0,124,0,123,0,115,0,144,0,56,0);
signal scenario_full  : scenario_type := (6,31,189,31,226,31,123,31,123,30,123,29,174,31,174,30,11,31,98,31,37,31,31,31,206,31,8,31,8,30,184,31,222,31,117,31,108,31,79,31,140,31,47,31,211,31,105,31,237,31,203,31,87,31,60,31,143,31,165,31,201,31,140,31,53,31,245,31,243,31,201,31,62,31,252,31,65,31,88,31,88,30,3,31,3,30,3,29,104,31,150,31,41,31,173,31,93,31,93,30,93,29,214,31,68,31,34,31,215,31,210,31,137,31,129,31,85,31,158,31,61,31,235,31,177,31,177,30,21,31,252,31,47,31,47,30,25,31,238,31,66,31,66,30,66,29,23,31,23,30,169,31,253,31,169,31,209,31,137,31,205,31,212,31,44,31,73,31,73,30,214,31,214,30,229,31,229,30,201,31,201,30,130,31,6,31,225,31,225,30,20,31,20,30,250,31,250,30,110,31,249,31,145,31,169,31,112,31,117,31,234,31,12,31,110,31,230,31,159,31,34,31,165,31,189,31,203,31,41,31,176,31,178,31,162,31,181,31,246,31,75,31,182,31,113,31,180,31,217,31,217,30,206,31,152,31,188,31,220,31,220,30,220,29,220,28,116,31,116,30,108,31,128,31,128,30,128,29,128,28,238,31,163,31,163,30,163,29,163,28,177,31,177,30,177,29,169,31,134,31,213,31,245,31,61,31,153,31,95,31,52,31,2,31,132,31,128,31,128,30,199,31,87,31,4,31,90,31,27,31,63,31,63,30,17,31,215,31,131,31,115,31,168,31,12,31,8,31,162,31,241,31,58,31,156,31,116,31,199,31,134,31,134,30,24,31,217,31,205,31,202,31,202,31,213,31,93,31,188,31,193,31,193,30,68,31,68,30,68,29,69,31,9,31,70,31,5,31,114,31,114,30,62,31,144,31,104,31,170,31,19,31,105,31,119,31,148,31,156,31,175,31,231,31,121,31,148,31,148,30,148,29,148,28,229,31,229,30,36,31,36,30,122,31,122,30,151,31,104,31,59,31,209,31,209,30,38,31,229,31,133,31,158,31,127,31,251,31,207,31,43,31,252,31,239,31,239,30,146,31,55,31,55,30,116,31,128,31,5,31,186,31,228,31,75,31,197,31,197,30,197,29,20,31,186,31,182,31,18,31,82,31,82,30,124,31,119,31,191,31,191,30,106,31,211,31,96,31,6,31,176,31,65,31,73,31,130,31,185,31,185,30,10,31,231,31,130,31,134,31,87,31,87,30,87,29,180,31,7,31,96,31,115,31,2,31,255,31,145,31,106,31,177,31,110,31,189,31,74,31,218,31,218,30,169,31,179,31,136,31,174,31,36,31,159,31,130,31,130,30,96,31,140,31,8,31,90,31,62,31,62,30,62,29,62,28,120,31,2,31,187,31,71,31,246,31,246,30,116,31,116,30,25,31,49,31,163,31,105,31,105,30,245,31,152,31,111,31,1,31,239,31,205,31,62,31,5,31,152,31,50,31,219,31,2,31,2,30,249,31,62,31,62,30,221,31,81,31,88,31,24,31,24,30,73,31,111,31,71,31,71,30,136,31,62,31,140,31,135,31,76,31,195,31,174,31,233,31,233,31,233,30,233,29,207,31,26,31,215,31,85,31,46,31,122,31,180,31,57,31,247,31,49,31,49,30,225,31,225,30,209,31,209,30,103,31,222,31,224,31,58,31,54,31,210,31,210,30,154,31,94,31,240,31,139,31,139,30,229,31,57,31,253,31,167,31,28,31,103,31,201,31,157,31,18,31,108,31,74,31,153,31,153,30,195,31,154,31,154,30,130,31,27,31,67,31,186,31,152,31,152,30,152,29,92,31,92,30,77,31,139,31,196,31,187,31,236,31,236,30,161,31,122,31,27,31,151,31,140,31,48,31,63,31,189,31,234,31,116,31,123,31,212,31,249,31,249,30,41,31,100,31,103,31,189,31,189,30,189,29,253,31,86,31,86,30,233,31,233,30,221,31,240,31,73,31,53,31,53,30,46,31,157,31,91,31,206,31,229,31,79,31,79,30,79,29,79,28,66,31,3,31,101,31,83,31,83,30,235,31,202,31,6,31,4,31,166,31,166,30,166,29,144,31,22,31,171,31,171,30,253,31,253,30,200,31,147,31,158,31,150,31,247,31,75,31,143,31,207,31,141,31,96,31,85,31,85,30,76,31,15,31,15,30,81,31,81,30,76,31,208,31,55,31,182,31,230,31,230,30,230,29,219,31,219,30,156,31,123,31,199,31,199,30,121,31,117,31,47,31,47,30,47,29,33,31,213,31,148,31,148,30,97,31,214,31,223,31,166,31,160,31,160,30,43,31,188,31,148,31,190,31,177,31,106,31,253,31,196,31,196,30,144,31,163,31,140,31,140,30,169,31,31,31,52,31,88,31,50,31,244,31,79,31,79,30,31,31,24,31,133,31,133,30,76,31,155,31,124,31,124,30,55,31,55,30,183,31,86,31,184,31,153,31,232,31,164,31,164,30,233,31,19,31,19,31,19,30,58,31,234,31,202,31,167,31,167,30,139,31,139,30,25,31,25,30,148,31,252,31,124,31,123,31,115,31,144,31,56,31);

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
