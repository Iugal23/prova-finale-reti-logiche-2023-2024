-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_482 is
end project_tb_482;

architecture project_tb_arch_482 of project_tb_482 is
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

constant SCENARIO_LENGTH : integer := 555;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (87,0,155,0,38,0,19,0,0,0,164,0,132,0,226,0,135,0,179,0,0,0,0,0,178,0,0,0,203,0,56,0,225,0,60,0,119,0,98,0,210,0,175,0,0,0,105,0,0,0,220,0,188,0,118,0,126,0,65,0,0,0,194,0,224,0,51,0,238,0,76,0,0,0,132,0,233,0,0,0,139,0,21,0,192,0,137,0,2,0,76,0,198,0,103,0,150,0,126,0,218,0,91,0,0,0,214,0,189,0,78,0,240,0,20,0,182,0,0,0,175,0,143,0,0,0,190,0,45,0,83,0,27,0,189,0,0,0,206,0,153,0,103,0,128,0,167,0,0,0,176,0,0,0,154,0,244,0,104,0,21,0,102,0,0,0,0,0,186,0,0,0,97,0,215,0,130,0,0,0,131,0,125,0,0,0,38,0,1,0,183,0,0,0,195,0,70,0,146,0,207,0,0,0,0,0,167,0,51,0,147,0,203,0,0,0,0,0,14,0,178,0,74,0,0,0,106,0,100,0,197,0,0,0,218,0,246,0,41,0,30,0,0,0,76,0,0,0,0,0,78,0,214,0,22,0,147,0,6,0,0,0,245,0,27,0,123,0,48,0,221,0,53,0,165,0,143,0,0,0,28,0,222,0,80,0,194,0,165,0,127,0,231,0,0,0,0,0,110,0,0,0,176,0,203,0,0,0,148,0,23,0,0,0,205,0,176,0,152,0,218,0,28,0,39,0,38,0,0,0,3,0,212,0,217,0,0,0,76,0,25,0,10,0,3,0,83,0,223,0,0,0,117,0,177,0,29,0,117,0,0,0,91,0,91,0,0,0,204,0,164,0,52,0,108,0,119,0,36,0,44,0,33,0,29,0,172,0,176,0,92,0,27,0,0,0,208,0,171,0,167,0,62,0,190,0,0,0,0,0,0,0,104,0,15,0,0,0,47,0,117,0,222,0,112,0,166,0,0,0,235,0,26,0,13,0,132,0,0,0,198,0,57,0,0,0,0,0,168,0,1,0,136,0,0,0,99,0,128,0,230,0,31,0,41,0,58,0,13,0,0,0,83,0,241,0,108,0,0,0,202,0,13,0,74,0,223,0,214,0,124,0,0,0,205,0,103,0,214,0,30,0,54,0,0,0,192,0,234,0,250,0,24,0,67,0,76,0,0,0,0,0,172,0,194,0,0,0,66,0,248,0,116,0,4,0,13,0,252,0,0,0,151,0,121,0,9,0,2,0,65,0,204,0,123,0,195,0,247,0,157,0,76,0,170,0,0,0,200,0,145,0,212,0,150,0,0,0,17,0,0,0,212,0,245,0,169,0,152,0,125,0,172,0,0,0,0,0,60,0,141,0,237,0,76,0,37,0,200,0,111,0,63,0,0,0,228,0,0,0,182,0,42,0,161,0,33,0,0,0,176,0,131,0,0,0,135,0,148,0,9,0,0,0,107,0,180,0,0,0,83,0,0,0,137,0,39,0,0,0,245,0,248,0,162,0,49,0,95,0,170,0,246,0,28,0,57,0,145,0,237,0,255,0,26,0,223,0,12,0,185,0,33,0,152,0,37,0,60,0,0,0,191,0,90,0,65,0,255,0,74,0,72,0,119,0,74,0,0,0,111,0,64,0,55,0,50,0,94,0,156,0,250,0,140,0,64,0,209,0,80,0,0,0,45,0,57,0,0,0,168,0,134,0,95,0,148,0,106,0,0,0,253,0,84,0,212,0,59,0,5,0,239,0,0,0,98,0,0,0,217,0,36,0,0,0,156,0,235,0,52,0,0,0,73,0,165,0,26,0,199,0,229,0,165,0,69,0,134,0,0,0,0,0,200,0,250,0,162,0,126,0,137,0,0,0,71,0,75,0,226,0,0,0,211,0,0,0,176,0,115,0,125,0,60,0,124,0,0,0,12,0,0,0,112,0,191,0,93,0,0,0,0,0,0,0,0,0,0,0,93,0,240,0,134,0,96,0,178,0,215,0,249,0,12,0,121,0,213,0,59,0,11,0,128,0,41,0,170,0,206,0,0,0,4,0,134,0,0,0,171,0,252,0,35,0,133,0,77,0,0,0,71,0,92,0,55,0,212,0,112,0,255,0,222,0,66,0,123,0,0,0,64,0,133,0,0,0,121,0,235,0,252,0,175,0,102,0,0,0,221,0,0,0,0,0,84,0,235,0,108,0,0,0,245,0,59,0,49,0,177,0,0,0,205,0,192,0,41,0,0,0,216,0,127,0,137,0,0,0,0,0,136,0,58,0,111,0,133,0,22,0,237,0,0,0,0,0,87,0,2,0,124,0,230,0,209,0,132,0,230,0,167,0,107,0,143,0,25,0,0,0,27,0,177,0,114,0,0,0,249,0,4,0,212,0,246,0,45,0,200,0,0,0,126,0,116,0,160,0,229,0,125,0,41,0,0,0,70,0,219,0,66,0,29,0,0,0,30,0,35,0,16,0,99,0,0,0,0,0,192,0,121,0,159,0,0,0,33,0);
signal scenario_full  : scenario_type := (87,31,155,31,38,31,19,31,19,30,164,31,132,31,226,31,135,31,179,31,179,30,179,29,178,31,178,30,203,31,56,31,225,31,60,31,119,31,98,31,210,31,175,31,175,30,105,31,105,30,220,31,188,31,118,31,126,31,65,31,65,30,194,31,224,31,51,31,238,31,76,31,76,30,132,31,233,31,233,30,139,31,21,31,192,31,137,31,2,31,76,31,198,31,103,31,150,31,126,31,218,31,91,31,91,30,214,31,189,31,78,31,240,31,20,31,182,31,182,30,175,31,143,31,143,30,190,31,45,31,83,31,27,31,189,31,189,30,206,31,153,31,103,31,128,31,167,31,167,30,176,31,176,30,154,31,244,31,104,31,21,31,102,31,102,30,102,29,186,31,186,30,97,31,215,31,130,31,130,30,131,31,125,31,125,30,38,31,1,31,183,31,183,30,195,31,70,31,146,31,207,31,207,30,207,29,167,31,51,31,147,31,203,31,203,30,203,29,14,31,178,31,74,31,74,30,106,31,100,31,197,31,197,30,218,31,246,31,41,31,30,31,30,30,76,31,76,30,76,29,78,31,214,31,22,31,147,31,6,31,6,30,245,31,27,31,123,31,48,31,221,31,53,31,165,31,143,31,143,30,28,31,222,31,80,31,194,31,165,31,127,31,231,31,231,30,231,29,110,31,110,30,176,31,203,31,203,30,148,31,23,31,23,30,205,31,176,31,152,31,218,31,28,31,39,31,38,31,38,30,3,31,212,31,217,31,217,30,76,31,25,31,10,31,3,31,83,31,223,31,223,30,117,31,177,31,29,31,117,31,117,30,91,31,91,31,91,30,204,31,164,31,52,31,108,31,119,31,36,31,44,31,33,31,29,31,172,31,176,31,92,31,27,31,27,30,208,31,171,31,167,31,62,31,190,31,190,30,190,29,190,28,104,31,15,31,15,30,47,31,117,31,222,31,112,31,166,31,166,30,235,31,26,31,13,31,132,31,132,30,198,31,57,31,57,30,57,29,168,31,1,31,136,31,136,30,99,31,128,31,230,31,31,31,41,31,58,31,13,31,13,30,83,31,241,31,108,31,108,30,202,31,13,31,74,31,223,31,214,31,124,31,124,30,205,31,103,31,214,31,30,31,54,31,54,30,192,31,234,31,250,31,24,31,67,31,76,31,76,30,76,29,172,31,194,31,194,30,66,31,248,31,116,31,4,31,13,31,252,31,252,30,151,31,121,31,9,31,2,31,65,31,204,31,123,31,195,31,247,31,157,31,76,31,170,31,170,30,200,31,145,31,212,31,150,31,150,30,17,31,17,30,212,31,245,31,169,31,152,31,125,31,172,31,172,30,172,29,60,31,141,31,237,31,76,31,37,31,200,31,111,31,63,31,63,30,228,31,228,30,182,31,42,31,161,31,33,31,33,30,176,31,131,31,131,30,135,31,148,31,9,31,9,30,107,31,180,31,180,30,83,31,83,30,137,31,39,31,39,30,245,31,248,31,162,31,49,31,95,31,170,31,246,31,28,31,57,31,145,31,237,31,255,31,26,31,223,31,12,31,185,31,33,31,152,31,37,31,60,31,60,30,191,31,90,31,65,31,255,31,74,31,72,31,119,31,74,31,74,30,111,31,64,31,55,31,50,31,94,31,156,31,250,31,140,31,64,31,209,31,80,31,80,30,45,31,57,31,57,30,168,31,134,31,95,31,148,31,106,31,106,30,253,31,84,31,212,31,59,31,5,31,239,31,239,30,98,31,98,30,217,31,36,31,36,30,156,31,235,31,52,31,52,30,73,31,165,31,26,31,199,31,229,31,165,31,69,31,134,31,134,30,134,29,200,31,250,31,162,31,126,31,137,31,137,30,71,31,75,31,226,31,226,30,211,31,211,30,176,31,115,31,125,31,60,31,124,31,124,30,12,31,12,30,112,31,191,31,93,31,93,30,93,29,93,28,93,27,93,26,93,31,240,31,134,31,96,31,178,31,215,31,249,31,12,31,121,31,213,31,59,31,11,31,128,31,41,31,170,31,206,31,206,30,4,31,134,31,134,30,171,31,252,31,35,31,133,31,77,31,77,30,71,31,92,31,55,31,212,31,112,31,255,31,222,31,66,31,123,31,123,30,64,31,133,31,133,30,121,31,235,31,252,31,175,31,102,31,102,30,221,31,221,30,221,29,84,31,235,31,108,31,108,30,245,31,59,31,49,31,177,31,177,30,205,31,192,31,41,31,41,30,216,31,127,31,137,31,137,30,137,29,136,31,58,31,111,31,133,31,22,31,237,31,237,30,237,29,87,31,2,31,124,31,230,31,209,31,132,31,230,31,167,31,107,31,143,31,25,31,25,30,27,31,177,31,114,31,114,30,249,31,4,31,212,31,246,31,45,31,200,31,200,30,126,31,116,31,160,31,229,31,125,31,41,31,41,30,70,31,219,31,66,31,29,31,29,30,30,31,35,31,16,31,99,31,99,30,99,29,192,31,121,31,159,31,159,30,33,31);

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
