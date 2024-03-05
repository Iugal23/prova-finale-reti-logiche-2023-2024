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

constant SCENARIO_LENGTH : integer := 469;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (197,0,148,0,164,0,16,0,169,0,175,0,183,0,171,0,254,0,74,0,21,0,74,0,197,0,13,0,126,0,153,0,95,0,75,0,188,0,128,0,0,0,74,0,124,0,65,0,0,0,89,0,79,0,11,0,0,0,3,0,188,0,115,0,42,0,253,0,66,0,63,0,176,0,171,0,0,0,200,0,154,0,249,0,210,0,185,0,92,0,0,0,103,0,203,0,0,0,122,0,116,0,219,0,101,0,171,0,0,0,204,0,124,0,203,0,216,0,91,0,0,0,130,0,175,0,217,0,0,0,98,0,118,0,0,0,26,0,243,0,166,0,249,0,80,0,225,0,0,0,0,0,241,0,208,0,175,0,43,0,63,0,99,0,110,0,194,0,105,0,132,0,193,0,55,0,202,0,0,0,131,0,89,0,107,0,136,0,65,0,0,0,0,0,0,0,81,0,147,0,144,0,0,0,111,0,230,0,0,0,204,0,0,0,54,0,200,0,96,0,254,0,204,0,54,0,0,0,27,0,0,0,146,0,0,0,0,0,123,0,0,0,35,0,188,0,206,0,39,0,142,0,0,0,51,0,150,0,3,0,229,0,69,0,0,0,227,0,144,0,5,0,0,0,82,0,27,0,58,0,100,0,0,0,160,0,67,0,215,0,250,0,91,0,148,0,176,0,0,0,0,0,238,0,151,0,0,0,83,0,10,0,195,0,185,0,220,0,9,0,162,0,118,0,189,0,83,0,0,0,236,0,75,0,222,0,0,0,165,0,0,0,69,0,0,0,0,0,140,0,30,0,80,0,175,0,172,0,0,0,221,0,69,0,207,0,210,0,173,0,0,0,177,0,36,0,41,0,247,0,238,0,183,0,0,0,54,0,24,0,182,0,83,0,170,0,13,0,0,0,197,0,48,0,135,0,173,0,221,0,171,0,38,0,149,0,159,0,26,0,0,0,142,0,0,0,218,0,248,0,162,0,165,0,41,0,187,0,40,0,26,0,85,0,124,0,171,0,213,0,53,0,193,0,55,0,25,0,81,0,204,0,148,0,196,0,214,0,0,0,0,0,100,0,0,0,153,0,237,0,50,0,252,0,29,0,60,0,26,0,145,0,114,0,48,0,11,0,0,0,73,0,247,0,49,0,251,0,124,0,199,0,0,0,0,0,17,0,64,0,10,0,44,0,233,0,11,0,6,0,205,0,254,0,139,0,0,0,199,0,52,0,0,0,0,0,53,0,69,0,79,0,44,0,59,0,0,0,148,0,180,0,0,0,203,0,0,0,98,0,0,0,110,0,235,0,99,0,0,0,127,0,92,0,253,0,14,0,155,0,137,0,78,0,136,0,132,0,239,0,169,0,0,0,104,0,154,0,52,0,249,0,171,0,0,0,187,0,152,0,80,0,2,0,22,0,237,0,49,0,183,0,0,0,0,0,0,0,250,0,22,0,0,0,202,0,134,0,223,0,23,0,186,0,59,0,0,0,0,0,211,0,147,0,0,0,180,0,150,0,0,0,196,0,16,0,23,0,252,0,0,0,215,0,98,0,216,0,99,0,0,0,249,0,156,0,55,0,64,0,0,0,0,0,17,0,0,0,103,0,249,0,234,0,0,0,0,0,110,0,191,0,111,0,0,0,154,0,0,0,209,0,170,0,0,0,124,0,118,0,42,0,0,0,63,0,240,0,55,0,190,0,0,0,138,0,0,0,245,0,245,0,68,0,23,0,26,0,32,0,8,0,203,0,77,0,190,0,2,0,103,0,81,0,134,0,0,0,109,0,169,0,0,0,131,0,102,0,161,0,136,0,143,0,26,0,99,0,120,0,33,0,85,0,120,0,2,0,92,0,56,0,36,0,110,0,0,0,0,0,194,0,34,0,6,0,119,0,38,0,0,0,224,0,4,0,248,0,234,0,0,0,30,0,182,0,212,0,74,0,0,0,101,0,0,0,6,0,98,0,190,0,67,0,127,0,8,0,150,0,155,0,255,0,177,0,4,0,0,0,209,0,0,0,253,0,194,0,0,0,17,0,171,0,0,0,148,0,250,0,0,0,58,0,199,0,48,0,42,0,143,0,71,0,140,0,199,0,3,0,165,0,189,0,222,0,170,0);
signal scenario_full  : scenario_type := (197,31,148,31,164,31,16,31,169,31,175,31,183,31,171,31,254,31,74,31,21,31,74,31,197,31,13,31,126,31,153,31,95,31,75,31,188,31,128,31,128,30,74,31,124,31,65,31,65,30,89,31,79,31,11,31,11,30,3,31,188,31,115,31,42,31,253,31,66,31,63,31,176,31,171,31,171,30,200,31,154,31,249,31,210,31,185,31,92,31,92,30,103,31,203,31,203,30,122,31,116,31,219,31,101,31,171,31,171,30,204,31,124,31,203,31,216,31,91,31,91,30,130,31,175,31,217,31,217,30,98,31,118,31,118,30,26,31,243,31,166,31,249,31,80,31,225,31,225,30,225,29,241,31,208,31,175,31,43,31,63,31,99,31,110,31,194,31,105,31,132,31,193,31,55,31,202,31,202,30,131,31,89,31,107,31,136,31,65,31,65,30,65,29,65,28,81,31,147,31,144,31,144,30,111,31,230,31,230,30,204,31,204,30,54,31,200,31,96,31,254,31,204,31,54,31,54,30,27,31,27,30,146,31,146,30,146,29,123,31,123,30,35,31,188,31,206,31,39,31,142,31,142,30,51,31,150,31,3,31,229,31,69,31,69,30,227,31,144,31,5,31,5,30,82,31,27,31,58,31,100,31,100,30,160,31,67,31,215,31,250,31,91,31,148,31,176,31,176,30,176,29,238,31,151,31,151,30,83,31,10,31,195,31,185,31,220,31,9,31,162,31,118,31,189,31,83,31,83,30,236,31,75,31,222,31,222,30,165,31,165,30,69,31,69,30,69,29,140,31,30,31,80,31,175,31,172,31,172,30,221,31,69,31,207,31,210,31,173,31,173,30,177,31,36,31,41,31,247,31,238,31,183,31,183,30,54,31,24,31,182,31,83,31,170,31,13,31,13,30,197,31,48,31,135,31,173,31,221,31,171,31,38,31,149,31,159,31,26,31,26,30,142,31,142,30,218,31,248,31,162,31,165,31,41,31,187,31,40,31,26,31,85,31,124,31,171,31,213,31,53,31,193,31,55,31,25,31,81,31,204,31,148,31,196,31,214,31,214,30,214,29,100,31,100,30,153,31,237,31,50,31,252,31,29,31,60,31,26,31,145,31,114,31,48,31,11,31,11,30,73,31,247,31,49,31,251,31,124,31,199,31,199,30,199,29,17,31,64,31,10,31,44,31,233,31,11,31,6,31,205,31,254,31,139,31,139,30,199,31,52,31,52,30,52,29,53,31,69,31,79,31,44,31,59,31,59,30,148,31,180,31,180,30,203,31,203,30,98,31,98,30,110,31,235,31,99,31,99,30,127,31,92,31,253,31,14,31,155,31,137,31,78,31,136,31,132,31,239,31,169,31,169,30,104,31,154,31,52,31,249,31,171,31,171,30,187,31,152,31,80,31,2,31,22,31,237,31,49,31,183,31,183,30,183,29,183,28,250,31,22,31,22,30,202,31,134,31,223,31,23,31,186,31,59,31,59,30,59,29,211,31,147,31,147,30,180,31,150,31,150,30,196,31,16,31,23,31,252,31,252,30,215,31,98,31,216,31,99,31,99,30,249,31,156,31,55,31,64,31,64,30,64,29,17,31,17,30,103,31,249,31,234,31,234,30,234,29,110,31,191,31,111,31,111,30,154,31,154,30,209,31,170,31,170,30,124,31,118,31,42,31,42,30,63,31,240,31,55,31,190,31,190,30,138,31,138,30,245,31,245,31,68,31,23,31,26,31,32,31,8,31,203,31,77,31,190,31,2,31,103,31,81,31,134,31,134,30,109,31,169,31,169,30,131,31,102,31,161,31,136,31,143,31,26,31,99,31,120,31,33,31,85,31,120,31,2,31,92,31,56,31,36,31,110,31,110,30,110,29,194,31,34,31,6,31,119,31,38,31,38,30,224,31,4,31,248,31,234,31,234,30,30,31,182,31,212,31,74,31,74,30,101,31,101,30,6,31,98,31,190,31,67,31,127,31,8,31,150,31,155,31,255,31,177,31,4,31,4,30,209,31,209,30,253,31,194,31,194,30,17,31,171,31,171,30,148,31,250,31,250,30,58,31,199,31,48,31,42,31,143,31,71,31,140,31,199,31,3,31,165,31,189,31,222,31,170,31);

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
