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

constant SCENARIO_LENGTH : integer := 339;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,180,0,34,0,22,0,21,0,230,0,149,0,0,0,0,0,137,0,43,0,102,0,227,0,47,0,0,0,4,0,57,0,165,0,164,0,10,0,103,0,176,0,254,0,173,0,24,0,54,0,32,0,0,0,238,0,214,0,216,0,73,0,0,0,57,0,0,0,0,0,251,0,199,0,33,0,178,0,8,0,185,0,118,0,0,0,93,0,73,0,0,0,19,0,0,0,0,0,0,0,126,0,0,0,69,0,102,0,0,0,69,0,52,0,148,0,0,0,237,0,37,0,78,0,0,0,215,0,102,0,91,0,204,0,25,0,92,0,118,0,45,0,235,0,36,0,65,0,195,0,223,0,0,0,109,0,164,0,161,0,8,0,189,0,6,0,0,0,215,0,0,0,0,0,203,0,204,0,0,0,206,0,170,0,218,0,0,0,121,0,169,0,86,0,10,0,0,0,117,0,0,0,84,0,244,0,0,0,149,0,131,0,145,0,140,0,39,0,214,0,161,0,0,0,223,0,0,0,46,0,140,0,195,0,0,0,73,0,81,0,184,0,188,0,0,0,207,0,50,0,134,0,0,0,0,0,0,0,242,0,83,0,169,0,249,0,163,0,12,0,0,0,138,0,0,0,247,0,160,0,10,0,118,0,55,0,55,0,174,0,52,0,179,0,132,0,0,0,57,0,29,0,58,0,36,0,200,0,135,0,193,0,23,0,104,0,176,0,226,0,21,0,59,0,99,0,51,0,174,0,191,0,216,0,65,0,169,0,0,0,166,0,0,0,0,0,183,0,179,0,54,0,23,0,242,0,227,0,56,0,118,0,0,0,0,0,122,0,241,0,236,0,234,0,85,0,0,0,76,0,156,0,18,0,0,0,29,0,84,0,76,0,157,0,108,0,229,0,89,0,167,0,22,0,196,0,88,0,61,0,252,0,33,0,218,0,144,0,42,0,49,0,0,0,5,0,99,0,0,0,125,0,31,0,0,0,239,0,0,0,28,0,0,0,211,0,188,0,4,0,71,0,0,0,0,0,167,0,0,0,175,0,57,0,1,0,241,0,54,0,67,0,170,0,0,0,135,0,94,0,0,0,105,0,63,0,97,0,213,0,38,0,230,0,165,0,126,0,105,0,174,0,100,0,247,0,235,0,11,0,63,0,183,0,129,0,188,0,105,0,157,0,147,0,165,0,0,0,25,0,154,0,241,0,35,0,96,0,0,0,0,0,227,0,211,0,161,0,82,0,105,0,97,0,150,0,2,0,14,0,0,0,121,0,17,0,0,0,78,0,202,0,0,0,162,0,107,0,10,0,18,0,0,0,0,0,66,0,54,0,51,0,61,0,0,0,59,0,126,0,240,0,240,0,154,0,182,0,41,0,221,0,0,0,46,0,95,0,214,0,0,0,0,0,0,0,16,0,186,0,0,0,0,0,73,0,135,0,189,0,232,0,192,0,235,0,27,0,51,0,176,0,0,0,24,0,0,0,75,0,0,0,10,0,72,0,0,0,214,0,12,0,233,0,0,0);
signal scenario_full  : scenario_type := (0,0,180,31,34,31,22,31,21,31,230,31,149,31,149,30,149,29,137,31,43,31,102,31,227,31,47,31,47,30,4,31,57,31,165,31,164,31,10,31,103,31,176,31,254,31,173,31,24,31,54,31,32,31,32,30,238,31,214,31,216,31,73,31,73,30,57,31,57,30,57,29,251,31,199,31,33,31,178,31,8,31,185,31,118,31,118,30,93,31,73,31,73,30,19,31,19,30,19,29,19,28,126,31,126,30,69,31,102,31,102,30,69,31,52,31,148,31,148,30,237,31,37,31,78,31,78,30,215,31,102,31,91,31,204,31,25,31,92,31,118,31,45,31,235,31,36,31,65,31,195,31,223,31,223,30,109,31,164,31,161,31,8,31,189,31,6,31,6,30,215,31,215,30,215,29,203,31,204,31,204,30,206,31,170,31,218,31,218,30,121,31,169,31,86,31,10,31,10,30,117,31,117,30,84,31,244,31,244,30,149,31,131,31,145,31,140,31,39,31,214,31,161,31,161,30,223,31,223,30,46,31,140,31,195,31,195,30,73,31,81,31,184,31,188,31,188,30,207,31,50,31,134,31,134,30,134,29,134,28,242,31,83,31,169,31,249,31,163,31,12,31,12,30,138,31,138,30,247,31,160,31,10,31,118,31,55,31,55,31,174,31,52,31,179,31,132,31,132,30,57,31,29,31,58,31,36,31,200,31,135,31,193,31,23,31,104,31,176,31,226,31,21,31,59,31,99,31,51,31,174,31,191,31,216,31,65,31,169,31,169,30,166,31,166,30,166,29,183,31,179,31,54,31,23,31,242,31,227,31,56,31,118,31,118,30,118,29,122,31,241,31,236,31,234,31,85,31,85,30,76,31,156,31,18,31,18,30,29,31,84,31,76,31,157,31,108,31,229,31,89,31,167,31,22,31,196,31,88,31,61,31,252,31,33,31,218,31,144,31,42,31,49,31,49,30,5,31,99,31,99,30,125,31,31,31,31,30,239,31,239,30,28,31,28,30,211,31,188,31,4,31,71,31,71,30,71,29,167,31,167,30,175,31,57,31,1,31,241,31,54,31,67,31,170,31,170,30,135,31,94,31,94,30,105,31,63,31,97,31,213,31,38,31,230,31,165,31,126,31,105,31,174,31,100,31,247,31,235,31,11,31,63,31,183,31,129,31,188,31,105,31,157,31,147,31,165,31,165,30,25,31,154,31,241,31,35,31,96,31,96,30,96,29,227,31,211,31,161,31,82,31,105,31,97,31,150,31,2,31,14,31,14,30,121,31,17,31,17,30,78,31,202,31,202,30,162,31,107,31,10,31,18,31,18,30,18,29,66,31,54,31,51,31,61,31,61,30,59,31,126,31,240,31,240,31,154,31,182,31,41,31,221,31,221,30,46,31,95,31,214,31,214,30,214,29,214,28,16,31,186,31,186,30,186,29,73,31,135,31,189,31,232,31,192,31,235,31,27,31,51,31,176,31,176,30,24,31,24,30,75,31,75,30,10,31,72,31,72,30,214,31,12,31,233,31,233,30);

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
