-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_651 is
end project_tb_651;

architecture project_tb_arch_651 of project_tb_651 is
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

constant SCENARIO_LENGTH : integer := 560;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (180,0,23,0,57,0,79,0,141,0,139,0,197,0,0,0,7,0,93,0,173,0,3,0,229,0,0,0,50,0,0,0,236,0,200,0,13,0,231,0,57,0,8,0,61,0,88,0,175,0,237,0,225,0,251,0,0,0,244,0,0,0,71,0,92,0,0,0,214,0,38,0,69,0,0,0,0,0,0,0,196,0,219,0,154,0,252,0,20,0,21,0,226,0,69,0,81,0,3,0,240,0,93,0,177,0,118,0,134,0,11,0,108,0,242,0,130,0,6,0,0,0,140,0,146,0,250,0,11,0,140,0,225,0,79,0,75,0,178,0,82,0,23,0,38,0,202,0,135,0,242,0,43,0,155,0,226,0,0,0,92,0,0,0,141,0,0,0,0,0,84,0,177,0,120,0,89,0,0,0,232,0,0,0,249,0,0,0,65,0,7,0,142,0,0,0,163,0,0,0,178,0,217,0,40,0,200,0,138,0,124,0,0,0,0,0,149,0,0,0,145,0,236,0,0,0,72,0,55,0,39,0,36,0,77,0,239,0,69,0,0,0,0,0,0,0,146,0,85,0,0,0,0,0,167,0,0,0,134,0,209,0,227,0,252,0,159,0,96,0,43,0,0,0,37,0,113,0,178,0,219,0,0,0,192,0,124,0,96,0,192,0,0,0,174,0,255,0,0,0,48,0,60,0,92,0,0,0,167,0,212,0,22,0,0,0,126,0,65,0,102,0,128,0,0,0,81,0,0,0,206,0,141,0,207,0,218,0,59,0,36,0,235,0,0,0,249,0,90,0,129,0,255,0,148,0,245,0,131,0,229,0,251,0,8,0,96,0,220,0,30,0,102,0,33,0,53,0,83,0,185,0,219,0,67,0,95,0,164,0,0,0,0,0,0,0,74,0,253,0,96,0,0,0,203,0,101,0,71,0,238,0,124,0,160,0,0,0,0,0,0,0,127,0,106,0,109,0,154,0,0,0,127,0,0,0,193,0,125,0,223,0,0,0,0,0,215,0,231,0,195,0,43,0,170,0,140,0,188,0,43,0,173,0,0,0,0,0,90,0,0,0,209,0,0,0,28,0,126,0,0,0,0,0,180,0,221,0,129,0,204,0,104,0,71,0,88,0,49,0,5,0,13,0,99,0,78,0,119,0,6,0,67,0,121,0,0,0,228,0,152,0,230,0,0,0,0,0,103,0,0,0,210,0,248,0,79,0,250,0,161,0,74,0,203,0,126,0,0,0,66,0,128,0,50,0,123,0,0,0,6,0,112,0,36,0,237,0,111,0,110,0,232,0,23,0,140,0,0,0,203,0,167,0,175,0,94,0,168,0,164,0,104,0,174,0,249,0,111,0,192,0,51,0,0,0,204,0,155,0,24,0,206,0,147,0,168,0,91,0,103,0,57,0,20,0,0,0,144,0,198,0,30,0,91,0,148,0,0,0,215,0,0,0,0,0,3,0,0,0,222,0,33,0,141,0,217,0,252,0,251,0,173,0,33,0,0,0,0,0,16,0,59,0,105,0,0,0,182,0,15,0,189,0,178,0,8,0,231,0,129,0,0,0,179,0,49,0,189,0,53,0,186,0,236,0,95,0,75,0,194,0,123,0,242,0,78,0,140,0,0,0,25,0,212,0,0,0,161,0,43,0,251,0,0,0,230,0,219,0,72,0,253,0,0,0,0,0,126,0,13,0,0,0,237,0,0,0,10,0,240,0,0,0,202,0,128,0,205,0,243,0,38,0,0,0,189,0,90,0,64,0,154,0,183,0,131,0,247,0,101,0,0,0,0,0,240,0,62,0,65,0,227,0,236,0,0,0,213,0,44,0,88,0,115,0,198,0,132,0,144,0,63,0,0,0,173,0,200,0,237,0,45,0,204,0,115,0,49,0,170,0,0,0,226,0,0,0,165,0,0,0,106,0,173,0,0,0,173,0,222,0,68,0,0,0,2,0,179,0,199,0,244,0,0,0,243,0,0,0,182,0,110,0,253,0,53,0,188,0,0,0,43,0,10,0,213,0,255,0,48,0,118,0,72,0,195,0,46,0,177,0,121,0,175,0,185,0,0,0,93,0,220,0,160,0,110,0,51,0,0,0,50,0,76,0,0,0,0,0,24,0,118,0,219,0,168,0,124,0,107,0,136,0,56,0,120,0,0,0,0,0,96,0,47,0,53,0,31,0,227,0,245,0,25,0,230,0,229,0,124,0,225,0,21,0,76,0,127,0,159,0,0,0,182,0,113,0,0,0,0,0,0,0,124,0,206,0,37,0,154,0,87,0,19,0,1,0,169,0,87,0,169,0,0,0,200,0,36,0,9,0,219,0,77,0,112,0,239,0,174,0,154,0,127,0,49,0,28,0,240,0,207,0,0,0,222,0,0,0,172,0,185,0,196,0,119,0,69,0,0,0,0,0,144,0,0,0,176,0,5,0,90,0,235,0,228,0,55,0,137,0,220,0,0,0,200,0,61,0,247,0,175,0,188,0,0,0,154,0,187,0,85,0,144,0,54,0,232,0);
signal scenario_full  : scenario_type := (180,31,23,31,57,31,79,31,141,31,139,31,197,31,197,30,7,31,93,31,173,31,3,31,229,31,229,30,50,31,50,30,236,31,200,31,13,31,231,31,57,31,8,31,61,31,88,31,175,31,237,31,225,31,251,31,251,30,244,31,244,30,71,31,92,31,92,30,214,31,38,31,69,31,69,30,69,29,69,28,196,31,219,31,154,31,252,31,20,31,21,31,226,31,69,31,81,31,3,31,240,31,93,31,177,31,118,31,134,31,11,31,108,31,242,31,130,31,6,31,6,30,140,31,146,31,250,31,11,31,140,31,225,31,79,31,75,31,178,31,82,31,23,31,38,31,202,31,135,31,242,31,43,31,155,31,226,31,226,30,92,31,92,30,141,31,141,30,141,29,84,31,177,31,120,31,89,31,89,30,232,31,232,30,249,31,249,30,65,31,7,31,142,31,142,30,163,31,163,30,178,31,217,31,40,31,200,31,138,31,124,31,124,30,124,29,149,31,149,30,145,31,236,31,236,30,72,31,55,31,39,31,36,31,77,31,239,31,69,31,69,30,69,29,69,28,146,31,85,31,85,30,85,29,167,31,167,30,134,31,209,31,227,31,252,31,159,31,96,31,43,31,43,30,37,31,113,31,178,31,219,31,219,30,192,31,124,31,96,31,192,31,192,30,174,31,255,31,255,30,48,31,60,31,92,31,92,30,167,31,212,31,22,31,22,30,126,31,65,31,102,31,128,31,128,30,81,31,81,30,206,31,141,31,207,31,218,31,59,31,36,31,235,31,235,30,249,31,90,31,129,31,255,31,148,31,245,31,131,31,229,31,251,31,8,31,96,31,220,31,30,31,102,31,33,31,53,31,83,31,185,31,219,31,67,31,95,31,164,31,164,30,164,29,164,28,74,31,253,31,96,31,96,30,203,31,101,31,71,31,238,31,124,31,160,31,160,30,160,29,160,28,127,31,106,31,109,31,154,31,154,30,127,31,127,30,193,31,125,31,223,31,223,30,223,29,215,31,231,31,195,31,43,31,170,31,140,31,188,31,43,31,173,31,173,30,173,29,90,31,90,30,209,31,209,30,28,31,126,31,126,30,126,29,180,31,221,31,129,31,204,31,104,31,71,31,88,31,49,31,5,31,13,31,99,31,78,31,119,31,6,31,67,31,121,31,121,30,228,31,152,31,230,31,230,30,230,29,103,31,103,30,210,31,248,31,79,31,250,31,161,31,74,31,203,31,126,31,126,30,66,31,128,31,50,31,123,31,123,30,6,31,112,31,36,31,237,31,111,31,110,31,232,31,23,31,140,31,140,30,203,31,167,31,175,31,94,31,168,31,164,31,104,31,174,31,249,31,111,31,192,31,51,31,51,30,204,31,155,31,24,31,206,31,147,31,168,31,91,31,103,31,57,31,20,31,20,30,144,31,198,31,30,31,91,31,148,31,148,30,215,31,215,30,215,29,3,31,3,30,222,31,33,31,141,31,217,31,252,31,251,31,173,31,33,31,33,30,33,29,16,31,59,31,105,31,105,30,182,31,15,31,189,31,178,31,8,31,231,31,129,31,129,30,179,31,49,31,189,31,53,31,186,31,236,31,95,31,75,31,194,31,123,31,242,31,78,31,140,31,140,30,25,31,212,31,212,30,161,31,43,31,251,31,251,30,230,31,219,31,72,31,253,31,253,30,253,29,126,31,13,31,13,30,237,31,237,30,10,31,240,31,240,30,202,31,128,31,205,31,243,31,38,31,38,30,189,31,90,31,64,31,154,31,183,31,131,31,247,31,101,31,101,30,101,29,240,31,62,31,65,31,227,31,236,31,236,30,213,31,44,31,88,31,115,31,198,31,132,31,144,31,63,31,63,30,173,31,200,31,237,31,45,31,204,31,115,31,49,31,170,31,170,30,226,31,226,30,165,31,165,30,106,31,173,31,173,30,173,31,222,31,68,31,68,30,2,31,179,31,199,31,244,31,244,30,243,31,243,30,182,31,110,31,253,31,53,31,188,31,188,30,43,31,10,31,213,31,255,31,48,31,118,31,72,31,195,31,46,31,177,31,121,31,175,31,185,31,185,30,93,31,220,31,160,31,110,31,51,31,51,30,50,31,76,31,76,30,76,29,24,31,118,31,219,31,168,31,124,31,107,31,136,31,56,31,120,31,120,30,120,29,96,31,47,31,53,31,31,31,227,31,245,31,25,31,230,31,229,31,124,31,225,31,21,31,76,31,127,31,159,31,159,30,182,31,113,31,113,30,113,29,113,28,124,31,206,31,37,31,154,31,87,31,19,31,1,31,169,31,87,31,169,31,169,30,200,31,36,31,9,31,219,31,77,31,112,31,239,31,174,31,154,31,127,31,49,31,28,31,240,31,207,31,207,30,222,31,222,30,172,31,185,31,196,31,119,31,69,31,69,30,69,29,144,31,144,30,176,31,5,31,90,31,235,31,228,31,55,31,137,31,220,31,220,30,200,31,61,31,247,31,175,31,188,31,188,30,154,31,187,31,85,31,144,31,54,31,232,31);

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
