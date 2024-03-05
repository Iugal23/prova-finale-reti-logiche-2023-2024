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

constant SCENARIO_LENGTH : integer := 267;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (117,0,209,0,165,0,194,0,218,0,0,0,0,0,211,0,182,0,66,0,171,0,53,0,155,0,106,0,36,0,101,0,2,0,13,0,32,0,18,0,69,0,143,0,0,0,115,0,144,0,35,0,122,0,199,0,220,0,64,0,143,0,0,0,117,0,0,0,34,0,253,0,121,0,0,0,118,0,122,0,7,0,86,0,211,0,0,0,221,0,0,0,112,0,102,0,239,0,61,0,179,0,187,0,62,0,137,0,0,0,89,0,69,0,244,0,250,0,0,0,0,0,245,0,235,0,212,0,141,0,0,0,0,0,239,0,0,0,167,0,93,0,99,0,56,0,60,0,51,0,69,0,110,0,190,0,59,0,56,0,172,0,46,0,49,0,71,0,94,0,125,0,98,0,0,0,175,0,57,0,115,0,79,0,0,0,172,0,186,0,243,0,188,0,113,0,43,0,113,0,171,0,0,0,74,0,6,0,0,0,60,0,198,0,46,0,191,0,107,0,183,0,38,0,253,0,8,0,139,0,142,0,0,0,120,0,169,0,87,0,110,0,246,0,90,0,37,0,68,0,220,0,88,0,42,0,70,0,0,0,31,0,174,0,0,0,145,0,0,0,38,0,82,0,15,0,100,0,211,0,249,0,6,0,0,0,180,0,0,0,54,0,87,0,66,0,0,0,241,0,160,0,249,0,115,0,76,0,0,0,0,0,49,0,152,0,8,0,250,0,243,0,0,0,31,0,0,0,24,0,50,0,175,0,99,0,142,0,29,0,0,0,123,0,19,0,74,0,53,0,208,0,67,0,202,0,79,0,157,0,202,0,164,0,248,0,179,0,91,0,144,0,50,0,169,0,175,0,158,0,156,0,0,0,44,0,42,0,64,0,0,0,40,0,39,0,26,0,239,0,116,0,0,0,55,0,174,0,63,0,95,0,7,0,230,0,0,0,68,0,53,0,166,0,0,0,178,0,199,0,129,0,0,0,85,0,113,0,96,0,30,0,224,0,0,0,252,0,77,0,188,0,172,0,145,0,217,0,43,0,0,0,179,0,188,0,144,0,244,0,0,0,0,0,128,0,151,0,57,0,0,0,158,0,132,0,79,0,0,0,102,0,14,0,80,0,3,0,0,0,41,0,186,0,100,0,199,0,0,0,0,0,80,0,172,0,248,0,21,0,91,0,0,0,0,0,170,0,208,0,0,0,42,0);
signal scenario_full  : scenario_type := (117,31,209,31,165,31,194,31,218,31,218,30,218,29,211,31,182,31,66,31,171,31,53,31,155,31,106,31,36,31,101,31,2,31,13,31,32,31,18,31,69,31,143,31,143,30,115,31,144,31,35,31,122,31,199,31,220,31,64,31,143,31,143,30,117,31,117,30,34,31,253,31,121,31,121,30,118,31,122,31,7,31,86,31,211,31,211,30,221,31,221,30,112,31,102,31,239,31,61,31,179,31,187,31,62,31,137,31,137,30,89,31,69,31,244,31,250,31,250,30,250,29,245,31,235,31,212,31,141,31,141,30,141,29,239,31,239,30,167,31,93,31,99,31,56,31,60,31,51,31,69,31,110,31,190,31,59,31,56,31,172,31,46,31,49,31,71,31,94,31,125,31,98,31,98,30,175,31,57,31,115,31,79,31,79,30,172,31,186,31,243,31,188,31,113,31,43,31,113,31,171,31,171,30,74,31,6,31,6,30,60,31,198,31,46,31,191,31,107,31,183,31,38,31,253,31,8,31,139,31,142,31,142,30,120,31,169,31,87,31,110,31,246,31,90,31,37,31,68,31,220,31,88,31,42,31,70,31,70,30,31,31,174,31,174,30,145,31,145,30,38,31,82,31,15,31,100,31,211,31,249,31,6,31,6,30,180,31,180,30,54,31,87,31,66,31,66,30,241,31,160,31,249,31,115,31,76,31,76,30,76,29,49,31,152,31,8,31,250,31,243,31,243,30,31,31,31,30,24,31,50,31,175,31,99,31,142,31,29,31,29,30,123,31,19,31,74,31,53,31,208,31,67,31,202,31,79,31,157,31,202,31,164,31,248,31,179,31,91,31,144,31,50,31,169,31,175,31,158,31,156,31,156,30,44,31,42,31,64,31,64,30,40,31,39,31,26,31,239,31,116,31,116,30,55,31,174,31,63,31,95,31,7,31,230,31,230,30,68,31,53,31,166,31,166,30,178,31,199,31,129,31,129,30,85,31,113,31,96,31,30,31,224,31,224,30,252,31,77,31,188,31,172,31,145,31,217,31,43,31,43,30,179,31,188,31,144,31,244,31,244,30,244,29,128,31,151,31,57,31,57,30,158,31,132,31,79,31,79,30,102,31,14,31,80,31,3,31,3,30,41,31,186,31,100,31,199,31,199,30,199,29,80,31,172,31,248,31,21,31,91,31,91,30,91,29,170,31,208,31,208,30,42,31);

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
