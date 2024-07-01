-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_7 is
end project_tb_7;

architecture project_tb_arch_7 of project_tb_7 is
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

constant SCENARIO_LENGTH : integer := 545;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (19,0,0,0,3,0,210,0,251,0,99,0,105,0,234,0,4,0,113,0,116,0,1,0,206,0,132,0,122,0,0,0,116,0,140,0,148,0,16,0,187,0,230,0,254,0,0,0,63,0,68,0,0,0,194,0,229,0,0,0,27,0,123,0,235,0,38,0,203,0,45,0,54,0,162,0,103,0,112,0,234,0,53,0,0,0,240,0,38,0,31,0,93,0,48,0,8,0,0,0,87,0,36,0,217,0,41,0,100,0,226,0,110,0,16,0,216,0,221,0,111,0,139,0,8,0,142,0,88,0,0,0,216,0,0,0,148,0,25,0,15,0,251,0,0,0,121,0,0,0,144,0,0,0,16,0,0,0,245,0,2,0,205,0,52,0,210,0,0,0,123,0,0,0,10,0,97,0,122,0,224,0,22,0,120,0,122,0,205,0,65,0,17,0,56,0,0,0,0,0,34,0,9,0,180,0,0,0,0,0,225,0,205,0,0,0,0,0,63,0,129,0,50,0,19,0,2,0,16,0,124,0,0,0,189,0,42,0,0,0,248,0,149,0,186,0,0,0,151,0,130,0,24,0,112,0,7,0,210,0,61,0,32,0,130,0,7,0,16,0,104,0,142,0,0,0,26,0,192,0,0,0,4,0,1,0,122,0,127,0,112,0,116,0,207,0,164,0,192,0,0,0,137,0,0,0,0,0,148,0,165,0,50,0,133,0,0,0,171,0,48,0,0,0,113,0,27,0,0,0,236,0,0,0,0,0,16,0,102,0,145,0,95,0,199,0,66,0,242,0,0,0,26,0,100,0,86,0,144,0,245,0,227,0,98,0,109,0,209,0,145,0,144,0,174,0,173,0,216,0,144,0,136,0,252,0,190,0,247,0,40,0,30,0,0,0,120,0,92,0,106,0,76,0,57,0,0,0,0,0,121,0,55,0,81,0,195,0,128,0,0,0,120,0,0,0,0,0,77,0,234,0,143,0,232,0,0,0,34,0,175,0,109,0,0,0,193,0,157,0,0,0,0,0,215,0,177,0,194,0,20,0,225,0,0,0,198,0,164,0,245,0,185,0,164,0,49,0,40,0,0,0,80,0,248,0,59,0,215,0,0,0,90,0,64,0,245,0,11,0,33,0,55,0,121,0,132,0,126,0,245,0,77,0,1,0,29,0,55,0,229,0,67,0,105,0,28,0,28,0,107,0,170,0,127,0,63,0,196,0,64,0,26,0,246,0,145,0,66,0,130,0,53,0,212,0,168,0,0,0,125,0,153,0,16,0,0,0,0,0,210,0,122,0,62,0,198,0,32,0,0,0,181,0,6,0,46,0,197,0,244,0,220,0,14,0,153,0,21,0,0,0,215,0,46,0,42,0,0,0,0,0,6,0,227,0,0,0,182,0,249,0,241,0,133,0,56,0,85,0,0,0,254,0,76,0,34,0,24,0,0,0,38,0,0,0,85,0,47,0,0,0,0,0,195,0,0,0,52,0,0,0,0,0,90,0,120,0,186,0,74,0,220,0,0,0,16,0,169,0,142,0,152,0,19,0,101,0,20,0,162,0,0,0,31,0,224,0,41,0,19,0,216,0,148,0,159,0,143,0,56,0,158,0,0,0,6,0,226,0,50,0,175,0,51,0,93,0,214,0,0,0,0,0,112,0,0,0,43,0,0,0,105,0,108,0,170,0,0,0,84,0,20,0,159,0,233,0,0,0,0,0,54,0,39,0,154,0,197,0,231,0,171,0,110,0,242,0,127,0,34,0,250,0,0,0,172,0,7,0,0,0,214,0,0,0,238,0,52,0,0,0,0,0,0,0,0,0,0,0,237,0,129,0,93,0,0,0,10,0,0,0,0,0,0,0,80,0,0,0,57,0,234,0,111,0,180,0,0,0,49,0,0,0,122,0,70,0,64,0,237,0,236,0,0,0,10,0,0,0,187,0,194,0,122,0,200,0,0,0,200,0,0,0,245,0,0,0,242,0,147,0,176,0,116,0,250,0,0,0,0,0,0,0,91,0,213,0,122,0,4,0,240,0,103,0,132,0,0,0,183,0,231,0,155,0,64,0,0,0,42,0,0,0,75,0,81,0,18,0,222,0,47,0,208,0,13,0,131,0,254,0,30,0,6,0,244,0,121,0,240,0,79,0,52,0,250,0,129,0,0,0,56,0,0,0,226,0,157,0,0,0,92,0,38,0,0,0,123,0,235,0,214,0,87,0,179,0,158,0,58,0,218,0,34,0,123,0,0,0,212,0,149,0,0,0,96,0,0,0,0,0,221,0,70,0,123,0,161,0,193,0,153,0,206,0,9,0,152,0,234,0,253,0,150,0,130,0,178,0,131,0,36,0,0,0,59,0,140,0,92,0,14,0,247,0,220,0,245,0,207,0,82,0,0,0,59,0,106,0,123,0,6,0,0,0,31,0,253,0,229,0,46,0,98,0,138,0,173,0);
signal scenario_full  : scenario_type := (19,31,19,30,3,31,210,31,251,31,99,31,105,31,234,31,4,31,113,31,116,31,1,31,206,31,132,31,122,31,122,30,116,31,140,31,148,31,16,31,187,31,230,31,254,31,254,30,63,31,68,31,68,30,194,31,229,31,229,30,27,31,123,31,235,31,38,31,203,31,45,31,54,31,162,31,103,31,112,31,234,31,53,31,53,30,240,31,38,31,31,31,93,31,48,31,8,31,8,30,87,31,36,31,217,31,41,31,100,31,226,31,110,31,16,31,216,31,221,31,111,31,139,31,8,31,142,31,88,31,88,30,216,31,216,30,148,31,25,31,15,31,251,31,251,30,121,31,121,30,144,31,144,30,16,31,16,30,245,31,2,31,205,31,52,31,210,31,210,30,123,31,123,30,10,31,97,31,122,31,224,31,22,31,120,31,122,31,205,31,65,31,17,31,56,31,56,30,56,29,34,31,9,31,180,31,180,30,180,29,225,31,205,31,205,30,205,29,63,31,129,31,50,31,19,31,2,31,16,31,124,31,124,30,189,31,42,31,42,30,248,31,149,31,186,31,186,30,151,31,130,31,24,31,112,31,7,31,210,31,61,31,32,31,130,31,7,31,16,31,104,31,142,31,142,30,26,31,192,31,192,30,4,31,1,31,122,31,127,31,112,31,116,31,207,31,164,31,192,31,192,30,137,31,137,30,137,29,148,31,165,31,50,31,133,31,133,30,171,31,48,31,48,30,113,31,27,31,27,30,236,31,236,30,236,29,16,31,102,31,145,31,95,31,199,31,66,31,242,31,242,30,26,31,100,31,86,31,144,31,245,31,227,31,98,31,109,31,209,31,145,31,144,31,174,31,173,31,216,31,144,31,136,31,252,31,190,31,247,31,40,31,30,31,30,30,120,31,92,31,106,31,76,31,57,31,57,30,57,29,121,31,55,31,81,31,195,31,128,31,128,30,120,31,120,30,120,29,77,31,234,31,143,31,232,31,232,30,34,31,175,31,109,31,109,30,193,31,157,31,157,30,157,29,215,31,177,31,194,31,20,31,225,31,225,30,198,31,164,31,245,31,185,31,164,31,49,31,40,31,40,30,80,31,248,31,59,31,215,31,215,30,90,31,64,31,245,31,11,31,33,31,55,31,121,31,132,31,126,31,245,31,77,31,1,31,29,31,55,31,229,31,67,31,105,31,28,31,28,31,107,31,170,31,127,31,63,31,196,31,64,31,26,31,246,31,145,31,66,31,130,31,53,31,212,31,168,31,168,30,125,31,153,31,16,31,16,30,16,29,210,31,122,31,62,31,198,31,32,31,32,30,181,31,6,31,46,31,197,31,244,31,220,31,14,31,153,31,21,31,21,30,215,31,46,31,42,31,42,30,42,29,6,31,227,31,227,30,182,31,249,31,241,31,133,31,56,31,85,31,85,30,254,31,76,31,34,31,24,31,24,30,38,31,38,30,85,31,47,31,47,30,47,29,195,31,195,30,52,31,52,30,52,29,90,31,120,31,186,31,74,31,220,31,220,30,16,31,169,31,142,31,152,31,19,31,101,31,20,31,162,31,162,30,31,31,224,31,41,31,19,31,216,31,148,31,159,31,143,31,56,31,158,31,158,30,6,31,226,31,50,31,175,31,51,31,93,31,214,31,214,30,214,29,112,31,112,30,43,31,43,30,105,31,108,31,170,31,170,30,84,31,20,31,159,31,233,31,233,30,233,29,54,31,39,31,154,31,197,31,231,31,171,31,110,31,242,31,127,31,34,31,250,31,250,30,172,31,7,31,7,30,214,31,214,30,238,31,52,31,52,30,52,29,52,28,52,27,52,26,237,31,129,31,93,31,93,30,10,31,10,30,10,29,10,28,80,31,80,30,57,31,234,31,111,31,180,31,180,30,49,31,49,30,122,31,70,31,64,31,237,31,236,31,236,30,10,31,10,30,187,31,194,31,122,31,200,31,200,30,200,31,200,30,245,31,245,30,242,31,147,31,176,31,116,31,250,31,250,30,250,29,250,28,91,31,213,31,122,31,4,31,240,31,103,31,132,31,132,30,183,31,231,31,155,31,64,31,64,30,42,31,42,30,75,31,81,31,18,31,222,31,47,31,208,31,13,31,131,31,254,31,30,31,6,31,244,31,121,31,240,31,79,31,52,31,250,31,129,31,129,30,56,31,56,30,226,31,157,31,157,30,92,31,38,31,38,30,123,31,235,31,214,31,87,31,179,31,158,31,58,31,218,31,34,31,123,31,123,30,212,31,149,31,149,30,96,31,96,30,96,29,221,31,70,31,123,31,161,31,193,31,153,31,206,31,9,31,152,31,234,31,253,31,150,31,130,31,178,31,131,31,36,31,36,30,59,31,140,31,92,31,14,31,247,31,220,31,245,31,207,31,82,31,82,30,59,31,106,31,123,31,6,31,6,30,31,31,253,31,229,31,46,31,98,31,138,31,173,31);

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
