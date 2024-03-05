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

constant SCENARIO_LENGTH : integer := 494;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,128,0,168,0,45,0,0,0,0,0,224,0,123,0,0,0,0,0,41,0,0,0,40,0,183,0,73,0,92,0,215,0,250,0,85,0,137,0,147,0,236,0,211,0,158,0,0,0,9,0,0,0,0,0,225,0,0,0,0,0,96,0,32,0,157,0,119,0,105,0,150,0,92,0,161,0,0,0,101,0,222,0,0,0,199,0,217,0,69,0,112,0,113,0,206,0,35,0,196,0,231,0,27,0,184,0,0,0,253,0,182,0,0,0,36,0,0,0,0,0,0,0,154,0,0,0,87,0,182,0,0,0,225,0,122,0,161,0,13,0,86,0,220,0,204,0,73,0,45,0,201,0,6,0,57,0,235,0,0,0,233,0,129,0,168,0,220,0,62,0,215,0,196,0,249,0,98,0,0,0,0,0,0,0,210,0,189,0,202,0,7,0,123,0,165,0,255,0,0,0,96,0,0,0,172,0,5,0,221,0,170,0,174,0,5,0,90,0,51,0,133,0,33,0,38,0,11,0,218,0,7,0,172,0,201,0,138,0,123,0,202,0,240,0,0,0,199,0,0,0,188,0,76,0,75,0,82,0,208,0,0,0,0,0,140,0,33,0,135,0,90,0,0,0,80,0,133,0,186,0,195,0,0,0,164,0,25,0,55,0,172,0,38,0,17,0,17,0,158,0,211,0,5,0,225,0,152,0,0,0,15,0,161,0,37,0,140,0,59,0,19,0,145,0,0,0,150,0,213,0,0,0,150,0,172,0,166,0,200,0,251,0,250,0,201,0,83,0,108,0,53,0,145,0,114,0,50,0,210,0,0,0,227,0,197,0,0,0,219,0,0,0,70,0,176,0,46,0,158,0,103,0,0,0,239,0,0,0,9,0,232,0,239,0,245,0,16,0,57,0,209,0,214,0,0,0,0,0,92,0,192,0,53,0,0,0,0,0,243,0,253,0,63,0,23,0,0,0,0,0,112,0,50,0,0,0,168,0,242,0,138,0,209,0,80,0,115,0,198,0,109,0,113,0,33,0,226,0,92,0,224,0,0,0,36,0,97,0,217,0,58,0,0,0,176,0,164,0,9,0,0,0,196,0,90,0,188,0,130,0,53,0,26,0,138,0,67,0,0,0,0,0,212,0,49,0,97,0,157,0,0,0,0,0,246,0,0,0,34,0,208,0,48,0,136,0,110,0,106,0,196,0,0,0,0,0,194,0,0,0,191,0,120,0,0,0,113,0,60,0,154,0,79,0,0,0,34,0,118,0,115,0,252,0,243,0,0,0,83,0,99,0,191,0,193,0,0,0,0,0,51,0,95,0,108,0,1,0,245,0,227,0,246,0,133,0,52,0,195,0,0,0,0,0,197,0,218,0,169,0,166,0,155,0,117,0,227,0,8,0,133,0,0,0,0,0,129,0,222,0,98,0,226,0,221,0,0,0,141,0,117,0,65,0,0,0,41,0,29,0,0,0,0,0,206,0,0,0,151,0,0,0,220,0,196,0,0,0,141,0,31,0,194,0,129,0,194,0,164,0,56,0,164,0,74,0,238,0,0,0,0,0,0,0,115,0,28,0,0,0,38,0,163,0,236,0,0,0,195,0,118,0,102,0,183,0,119,0,208,0,202,0,113,0,0,0,153,0,135,0,20,0,34,0,101,0,153,0,0,0,5,0,233,0,55,0,144,0,235,0,0,0,0,0,142,0,52,0,0,0,0,0,51,0,123,0,0,0,0,0,67,0,0,0,0,0,76,0,204,0,195,0,232,0,85,0,159,0,157,0,170,0,222,0,94,0,90,0,0,0,82,0,0,0,237,0,0,0,27,0,78,0,27,0,0,0,29,0,113,0,102,0,246,0,126,0,93,0,0,0,0,0,184,0,162,0,68,0,192,0,48,0,242,0,122,0,195,0,249,0,0,0,225,0,180,0,0,0,87,0,225,0,212,0,30,0,165,0,227,0,0,0,218,0,155,0,18,0,142,0,134,0,0,0,118,0,0,0,0,0,174,0,24,0,192,0,195,0,76,0,86,0,188,0,70,0,69,0,0,0,238,0,177,0,35,0,238,0,104,0,255,0,0,0,24,0,32,0,0,0,183,0,36,0,110,0,94,0,6,0,228,0,206,0,156,0,204,0,234,0,106,0,97,0,144,0,0,0,104,0,47,0,196,0,227,0,12,0,225,0,0,0,148,0,0,0,230,0,90,0,189,0,199,0,79,0);
signal scenario_full  : scenario_type := (0,0,128,31,168,31,45,31,45,30,45,29,224,31,123,31,123,30,123,29,41,31,41,30,40,31,183,31,73,31,92,31,215,31,250,31,85,31,137,31,147,31,236,31,211,31,158,31,158,30,9,31,9,30,9,29,225,31,225,30,225,29,96,31,32,31,157,31,119,31,105,31,150,31,92,31,161,31,161,30,101,31,222,31,222,30,199,31,217,31,69,31,112,31,113,31,206,31,35,31,196,31,231,31,27,31,184,31,184,30,253,31,182,31,182,30,36,31,36,30,36,29,36,28,154,31,154,30,87,31,182,31,182,30,225,31,122,31,161,31,13,31,86,31,220,31,204,31,73,31,45,31,201,31,6,31,57,31,235,31,235,30,233,31,129,31,168,31,220,31,62,31,215,31,196,31,249,31,98,31,98,30,98,29,98,28,210,31,189,31,202,31,7,31,123,31,165,31,255,31,255,30,96,31,96,30,172,31,5,31,221,31,170,31,174,31,5,31,90,31,51,31,133,31,33,31,38,31,11,31,218,31,7,31,172,31,201,31,138,31,123,31,202,31,240,31,240,30,199,31,199,30,188,31,76,31,75,31,82,31,208,31,208,30,208,29,140,31,33,31,135,31,90,31,90,30,80,31,133,31,186,31,195,31,195,30,164,31,25,31,55,31,172,31,38,31,17,31,17,31,158,31,211,31,5,31,225,31,152,31,152,30,15,31,161,31,37,31,140,31,59,31,19,31,145,31,145,30,150,31,213,31,213,30,150,31,172,31,166,31,200,31,251,31,250,31,201,31,83,31,108,31,53,31,145,31,114,31,50,31,210,31,210,30,227,31,197,31,197,30,219,31,219,30,70,31,176,31,46,31,158,31,103,31,103,30,239,31,239,30,9,31,232,31,239,31,245,31,16,31,57,31,209,31,214,31,214,30,214,29,92,31,192,31,53,31,53,30,53,29,243,31,253,31,63,31,23,31,23,30,23,29,112,31,50,31,50,30,168,31,242,31,138,31,209,31,80,31,115,31,198,31,109,31,113,31,33,31,226,31,92,31,224,31,224,30,36,31,97,31,217,31,58,31,58,30,176,31,164,31,9,31,9,30,196,31,90,31,188,31,130,31,53,31,26,31,138,31,67,31,67,30,67,29,212,31,49,31,97,31,157,31,157,30,157,29,246,31,246,30,34,31,208,31,48,31,136,31,110,31,106,31,196,31,196,30,196,29,194,31,194,30,191,31,120,31,120,30,113,31,60,31,154,31,79,31,79,30,34,31,118,31,115,31,252,31,243,31,243,30,83,31,99,31,191,31,193,31,193,30,193,29,51,31,95,31,108,31,1,31,245,31,227,31,246,31,133,31,52,31,195,31,195,30,195,29,197,31,218,31,169,31,166,31,155,31,117,31,227,31,8,31,133,31,133,30,133,29,129,31,222,31,98,31,226,31,221,31,221,30,141,31,117,31,65,31,65,30,41,31,29,31,29,30,29,29,206,31,206,30,151,31,151,30,220,31,196,31,196,30,141,31,31,31,194,31,129,31,194,31,164,31,56,31,164,31,74,31,238,31,238,30,238,29,238,28,115,31,28,31,28,30,38,31,163,31,236,31,236,30,195,31,118,31,102,31,183,31,119,31,208,31,202,31,113,31,113,30,153,31,135,31,20,31,34,31,101,31,153,31,153,30,5,31,233,31,55,31,144,31,235,31,235,30,235,29,142,31,52,31,52,30,52,29,51,31,123,31,123,30,123,29,67,31,67,30,67,29,76,31,204,31,195,31,232,31,85,31,159,31,157,31,170,31,222,31,94,31,90,31,90,30,82,31,82,30,237,31,237,30,27,31,78,31,27,31,27,30,29,31,113,31,102,31,246,31,126,31,93,31,93,30,93,29,184,31,162,31,68,31,192,31,48,31,242,31,122,31,195,31,249,31,249,30,225,31,180,31,180,30,87,31,225,31,212,31,30,31,165,31,227,31,227,30,218,31,155,31,18,31,142,31,134,31,134,30,118,31,118,30,118,29,174,31,24,31,192,31,195,31,76,31,86,31,188,31,70,31,69,31,69,30,238,31,177,31,35,31,238,31,104,31,255,31,255,30,24,31,32,31,32,30,183,31,36,31,110,31,94,31,6,31,228,31,206,31,156,31,204,31,234,31,106,31,97,31,144,31,144,30,104,31,47,31,196,31,227,31,12,31,225,31,225,30,148,31,148,30,230,31,90,31,189,31,199,31,79,31);

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
