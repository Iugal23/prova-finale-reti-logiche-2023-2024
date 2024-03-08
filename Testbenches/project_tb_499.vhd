-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_499 is
end project_tb_499;

architecture project_tb_arch_499 of project_tb_499 is
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

constant SCENARIO_LENGTH : integer := 445;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,249,0,92,0,26,0,71,0,162,0,142,0,159,0,26,0,193,0,106,0,68,0,205,0,0,0,60,0,33,0,0,0,70,0,68,0,27,0,140,0,82,0,236,0,0,0,26,0,221,0,22,0,52,0,24,0,8,0,15,0,254,0,164,0,0,0,0,0,0,0,251,0,110,0,0,0,35,0,139,0,63,0,126,0,0,0,8,0,232,0,161,0,50,0,240,0,0,0,222,0,33,0,0,0,0,0,123,0,115,0,220,0,165,0,0,0,29,0,177,0,15,0,0,0,217,0,231,0,3,0,122,0,247,0,0,0,123,0,112,0,171,0,154,0,106,0,234,0,249,0,97,0,5,0,0,0,188,0,197,0,45,0,0,0,62,0,249,0,248,0,128,0,74,0,28,0,223,0,15,0,143,0,46,0,155,0,170,0,195,0,0,0,0,0,169,0,108,0,140,0,0,0,142,0,210,0,64,0,87,0,68,0,46,0,47,0,0,0,59,0,165,0,6,0,33,0,99,0,223,0,0,0,175,0,198,0,0,0,152,0,239,0,39,0,49,0,139,0,141,0,157,0,0,0,235,0,47,0,70,0,0,0,251,0,54,0,210,0,5,0,209,0,20,0,0,0,77,0,51,0,112,0,133,0,30,0,168,0,0,0,129,0,223,0,0,0,51,0,223,0,157,0,162,0,197,0,228,0,138,0,118,0,0,0,128,0,103,0,241,0,16,0,0,0,180,0,164,0,11,0,190,0,55,0,163,0,175,0,173,0,129,0,250,0,55,0,0,0,114,0,187,0,0,0,0,0,200,0,0,0,158,0,228,0,112,0,207,0,235,0,0,0,84,0,36,0,71,0,32,0,103,0,37,0,37,0,243,0,174,0,174,0,245,0,199,0,0,0,129,0,238,0,0,0,64,0,47,0,66,0,164,0,237,0,162,0,89,0,64,0,133,0,230,0,88,0,239,0,142,0,222,0,53,0,0,0,108,0,137,0,111,0,20,0,240,0,239,0,67,0,110,0,96,0,231,0,0,0,0,0,161,0,52,0,116,0,196,0,57,0,0,0,58,0,61,0,0,0,240,0,221,0,211,0,129,0,156,0,222,0,105,0,208,0,153,0,35,0,0,0,213,0,113,0,0,0,19,0,0,0,164,0,145,0,61,0,110,0,45,0,54,0,40,0,228,0,24,0,18,0,117,0,201,0,194,0,0,0,0,0,4,0,151,0,81,0,232,0,27,0,214,0,0,0,146,0,92,0,0,0,159,0,117,0,0,0,0,0,71,0,0,0,123,0,39,0,141,0,28,0,77,0,0,0,245,0,32,0,114,0,21,0,0,0,106,0,63,0,129,0,19,0,58,0,0,0,62,0,126,0,81,0,222,0,0,0,87,0,84,0,255,0,0,0,11,0,133,0,53,0,49,0,253,0,255,0,110,0,160,0,116,0,230,0,83,0,83,0,0,0,83,0,207,0,148,0,188,0,184,0,36,0,158,0,241,0,0,0,201,0,100,0,61,0,125,0,0,0,106,0,98,0,235,0,43,0,0,0,160,0,168,0,0,0,0,0,233,0,250,0,253,0,50,0,103,0,0,0,12,0,191,0,59,0,82,0,0,0,0,0,101,0,160,0,0,0,154,0,208,0,21,0,76,0,61,0,84,0,172,0,235,0,84,0,228,0,183,0,240,0,133,0,233,0,182,0,197,0,218,0,234,0,15,0,0,0,29,0,0,0,110,0,0,0,144,0,235,0,121,0,202,0,57,0,105,0,212,0,248,0,73,0,137,0,88,0,198,0,0,0,154,0,55,0,248,0,0,0,0,0,68,0,0,0,112,0,49,0,17,0,26,0,208,0,0,0,155,0,202,0,220,0,226,0,226,0,37,0,49,0,79,0,171,0,190,0,0,0,52,0,141,0,0,0,169,0,210,0,132,0,35,0,36,0,73,0,120,0,245,0,211,0,220,0,61,0,0,0,96,0,239,0,0,0,100,0);
signal scenario_full  : scenario_type := (0,0,0,0,249,31,92,31,26,31,71,31,162,31,142,31,159,31,26,31,193,31,106,31,68,31,205,31,205,30,60,31,33,31,33,30,70,31,68,31,27,31,140,31,82,31,236,31,236,30,26,31,221,31,22,31,52,31,24,31,8,31,15,31,254,31,164,31,164,30,164,29,164,28,251,31,110,31,110,30,35,31,139,31,63,31,126,31,126,30,8,31,232,31,161,31,50,31,240,31,240,30,222,31,33,31,33,30,33,29,123,31,115,31,220,31,165,31,165,30,29,31,177,31,15,31,15,30,217,31,231,31,3,31,122,31,247,31,247,30,123,31,112,31,171,31,154,31,106,31,234,31,249,31,97,31,5,31,5,30,188,31,197,31,45,31,45,30,62,31,249,31,248,31,128,31,74,31,28,31,223,31,15,31,143,31,46,31,155,31,170,31,195,31,195,30,195,29,169,31,108,31,140,31,140,30,142,31,210,31,64,31,87,31,68,31,46,31,47,31,47,30,59,31,165,31,6,31,33,31,99,31,223,31,223,30,175,31,198,31,198,30,152,31,239,31,39,31,49,31,139,31,141,31,157,31,157,30,235,31,47,31,70,31,70,30,251,31,54,31,210,31,5,31,209,31,20,31,20,30,77,31,51,31,112,31,133,31,30,31,168,31,168,30,129,31,223,31,223,30,51,31,223,31,157,31,162,31,197,31,228,31,138,31,118,31,118,30,128,31,103,31,241,31,16,31,16,30,180,31,164,31,11,31,190,31,55,31,163,31,175,31,173,31,129,31,250,31,55,31,55,30,114,31,187,31,187,30,187,29,200,31,200,30,158,31,228,31,112,31,207,31,235,31,235,30,84,31,36,31,71,31,32,31,103,31,37,31,37,31,243,31,174,31,174,31,245,31,199,31,199,30,129,31,238,31,238,30,64,31,47,31,66,31,164,31,237,31,162,31,89,31,64,31,133,31,230,31,88,31,239,31,142,31,222,31,53,31,53,30,108,31,137,31,111,31,20,31,240,31,239,31,67,31,110,31,96,31,231,31,231,30,231,29,161,31,52,31,116,31,196,31,57,31,57,30,58,31,61,31,61,30,240,31,221,31,211,31,129,31,156,31,222,31,105,31,208,31,153,31,35,31,35,30,213,31,113,31,113,30,19,31,19,30,164,31,145,31,61,31,110,31,45,31,54,31,40,31,228,31,24,31,18,31,117,31,201,31,194,31,194,30,194,29,4,31,151,31,81,31,232,31,27,31,214,31,214,30,146,31,92,31,92,30,159,31,117,31,117,30,117,29,71,31,71,30,123,31,39,31,141,31,28,31,77,31,77,30,245,31,32,31,114,31,21,31,21,30,106,31,63,31,129,31,19,31,58,31,58,30,62,31,126,31,81,31,222,31,222,30,87,31,84,31,255,31,255,30,11,31,133,31,53,31,49,31,253,31,255,31,110,31,160,31,116,31,230,31,83,31,83,31,83,30,83,31,207,31,148,31,188,31,184,31,36,31,158,31,241,31,241,30,201,31,100,31,61,31,125,31,125,30,106,31,98,31,235,31,43,31,43,30,160,31,168,31,168,30,168,29,233,31,250,31,253,31,50,31,103,31,103,30,12,31,191,31,59,31,82,31,82,30,82,29,101,31,160,31,160,30,154,31,208,31,21,31,76,31,61,31,84,31,172,31,235,31,84,31,228,31,183,31,240,31,133,31,233,31,182,31,197,31,218,31,234,31,15,31,15,30,29,31,29,30,110,31,110,30,144,31,235,31,121,31,202,31,57,31,105,31,212,31,248,31,73,31,137,31,88,31,198,31,198,30,154,31,55,31,248,31,248,30,248,29,68,31,68,30,112,31,49,31,17,31,26,31,208,31,208,30,155,31,202,31,220,31,226,31,226,31,37,31,49,31,79,31,171,31,190,31,190,30,52,31,141,31,141,30,169,31,210,31,132,31,35,31,36,31,73,31,120,31,245,31,211,31,220,31,61,31,61,30,96,31,239,31,239,30,100,31);

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
