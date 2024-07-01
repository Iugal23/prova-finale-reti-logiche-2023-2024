-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_300 is
end project_tb_300;

architecture project_tb_arch_300 of project_tb_300 is
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

constant SCENARIO_LENGTH : integer := 580;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,233,0,168,0,19,0,180,0,234,0,143,0,130,0,0,0,0,0,87,0,120,0,0,0,0,0,171,0,100,0,0,0,68,0,154,0,62,0,249,0,53,0,117,0,0,0,0,0,0,0,202,0,200,0,0,0,103,0,154,0,0,0,171,0,186,0,98,0,88,0,0,0,159,0,0,0,0,0,101,0,248,0,0,0,56,0,122,0,106,0,187,0,7,0,93,0,15,0,157,0,60,0,230,0,0,0,130,0,190,0,103,0,234,0,75,0,40,0,225,0,37,0,74,0,93,0,226,0,210,0,94,0,147,0,0,0,121,0,182,0,40,0,47,0,0,0,51,0,124,0,0,0,0,0,133,0,31,0,205,0,251,0,96,0,254,0,10,0,163,0,204,0,182,0,23,0,62,0,37,0,244,0,192,0,0,0,149,0,200,0,201,0,183,0,58,0,133,0,155,0,0,0,48,0,164,0,0,0,115,0,50,0,211,0,0,0,48,0,151,0,56,0,39,0,156,0,0,0,240,0,47,0,0,0,198,0,154,0,243,0,157,0,131,0,239,0,111,0,226,0,21,0,232,0,0,0,0,0,107,0,114,0,238,0,91,0,162,0,119,0,51,0,182,0,142,0,183,0,154,0,0,0,141,0,97,0,62,0,41,0,57,0,217,0,216,0,213,0,0,0,121,0,238,0,0,0,0,0,0,0,0,0,150,0,173,0,0,0,235,0,229,0,216,0,138,0,194,0,204,0,169,0,221,0,120,0,213,0,106,0,224,0,144,0,87,0,240,0,133,0,240,0,57,0,3,0,0,0,87,0,165,0,213,0,101,0,85,0,0,0,168,0,130,0,0,0,244,0,0,0,106,0,62,0,236,0,110,0,170,0,243,0,0,0,203,0,0,0,60,0,157,0,1,0,19,0,240,0,39,0,42,0,177,0,55,0,202,0,209,0,145,0,30,0,172,0,200,0,183,0,0,0,216,0,247,0,33,0,205,0,0,0,40,0,77,0,115,0,25,0,141,0,0,0,0,0,220,0,182,0,69,0,36,0,239,0,171,0,0,0,79,0,225,0,17,0,250,0,89,0,223,0,0,0,144,0,33,0,0,0,190,0,107,0,233,0,38,0,0,0,0,0,88,0,83,0,162,0,79,0,122,0,189,0,0,0,48,0,0,0,255,0,41,0,93,0,159,0,97,0,0,0,88,0,252,0,0,0,0,0,6,0,10,0,223,0,213,0,69,0,137,0,78,0,177,0,0,0,207,0,47,0,47,0,0,0,0,0,158,0,0,0,23,0,62,0,0,0,93,0,159,0,78,0,165,0,179,0,95,0,210,0,223,0,133,0,53,0,65,0,200,0,0,0,156,0,207,0,145,0,0,0,171,0,40,0,151,0,0,0,31,0,38,0,219,0,0,0,26,0,206,0,38,0,0,0,0,0,246,0,126,0,225,0,222,0,130,0,197,0,127,0,12,0,134,0,4,0,106,0,69,0,72,0,146,0,20,0,163,0,209,0,55,0,113,0,173,0,0,0,212,0,155,0,228,0,86,0,226,0,111,0,0,0,20,0,157,0,43,0,0,0,249,0,0,0,229,0,0,0,0,0,198,0,15,0,235,0,141,0,87,0,6,0,198,0,107,0,0,0,81,0,148,0,246,0,0,0,208,0,199,0,16,0,159,0,97,0,9,0,149,0,89,0,176,0,208,0,59,0,183,0,0,0,19,0,67,0,137,0,53,0,0,0,201,0,25,0,93,0,250,0,71,0,50,0,45,0,115,0,0,0,179,0,67,0,113,0,98,0,0,0,132,0,131,0,251,0,168,0,127,0,51,0,254,0,177,0,154,0,162,0,167,0,235,0,0,0,0,0,150,0,41,0,82,0,236,0,0,0,0,0,216,0,0,0,6,0,13,0,2,0,220,0,72,0,0,0,0,0,0,0,214,0,167,0,11,0,106,0,33,0,0,0,0,0,129,0,76,0,69,0,133,0,187,0,241,0,0,0,143,0,0,0,210,0,148,0,19,0,0,0,24,0,196,0,21,0,0,0,136,0,0,0,141,0,200,0,182,0,186,0,6,0,26,0,93,0,0,0,217,0,13,0,149,0,55,0,0,0,138,0,52,0,36,0,127,0,164,0,89,0,216,0,140,0,0,0,148,0,95,0,167,0,77,0,81,0,20,0,163,0,0,0,91,0,57,0,96,0,0,0,48,0,93,0,239,0,0,0,189,0,234,0,0,0,22,0,193,0,34,0,0,0,0,0,159,0,160,0,0,0,1,0,0,0,0,0,234,0,43,0,116,0,75,0,14,0,66,0,0,0,53,0,165,0,47,0,210,0,178,0,149,0,39,0,18,0,61,0,39,0,26,0,106,0,0,0,124,0,215,0,231,0,135,0,37,0,0,0,146,0,64,0,168,0,29,0,207,0,0,0,57,0,42,0,210,0,150,0,0,0,129,0,173,0,0,0,0,0,64,0,0,0,0,0,122,0,105,0,42,0,159,0,8,0,0,0,18,0,15,0,0,0,205,0,13,0,165,0,0,0,147,0,207,0,0,0,232,0,147,0,139,0,112,0,0,0,59,0,31,0,203,0,0,0,165,0);
signal scenario_full  : scenario_type := (0,0,233,31,168,31,19,31,180,31,234,31,143,31,130,31,130,30,130,29,87,31,120,31,120,30,120,29,171,31,100,31,100,30,68,31,154,31,62,31,249,31,53,31,117,31,117,30,117,29,117,28,202,31,200,31,200,30,103,31,154,31,154,30,171,31,186,31,98,31,88,31,88,30,159,31,159,30,159,29,101,31,248,31,248,30,56,31,122,31,106,31,187,31,7,31,93,31,15,31,157,31,60,31,230,31,230,30,130,31,190,31,103,31,234,31,75,31,40,31,225,31,37,31,74,31,93,31,226,31,210,31,94,31,147,31,147,30,121,31,182,31,40,31,47,31,47,30,51,31,124,31,124,30,124,29,133,31,31,31,205,31,251,31,96,31,254,31,10,31,163,31,204,31,182,31,23,31,62,31,37,31,244,31,192,31,192,30,149,31,200,31,201,31,183,31,58,31,133,31,155,31,155,30,48,31,164,31,164,30,115,31,50,31,211,31,211,30,48,31,151,31,56,31,39,31,156,31,156,30,240,31,47,31,47,30,198,31,154,31,243,31,157,31,131,31,239,31,111,31,226,31,21,31,232,31,232,30,232,29,107,31,114,31,238,31,91,31,162,31,119,31,51,31,182,31,142,31,183,31,154,31,154,30,141,31,97,31,62,31,41,31,57,31,217,31,216,31,213,31,213,30,121,31,238,31,238,30,238,29,238,28,238,27,150,31,173,31,173,30,235,31,229,31,216,31,138,31,194,31,204,31,169,31,221,31,120,31,213,31,106,31,224,31,144,31,87,31,240,31,133,31,240,31,57,31,3,31,3,30,87,31,165,31,213,31,101,31,85,31,85,30,168,31,130,31,130,30,244,31,244,30,106,31,62,31,236,31,110,31,170,31,243,31,243,30,203,31,203,30,60,31,157,31,1,31,19,31,240,31,39,31,42,31,177,31,55,31,202,31,209,31,145,31,30,31,172,31,200,31,183,31,183,30,216,31,247,31,33,31,205,31,205,30,40,31,77,31,115,31,25,31,141,31,141,30,141,29,220,31,182,31,69,31,36,31,239,31,171,31,171,30,79,31,225,31,17,31,250,31,89,31,223,31,223,30,144,31,33,31,33,30,190,31,107,31,233,31,38,31,38,30,38,29,88,31,83,31,162,31,79,31,122,31,189,31,189,30,48,31,48,30,255,31,41,31,93,31,159,31,97,31,97,30,88,31,252,31,252,30,252,29,6,31,10,31,223,31,213,31,69,31,137,31,78,31,177,31,177,30,207,31,47,31,47,31,47,30,47,29,158,31,158,30,23,31,62,31,62,30,93,31,159,31,78,31,165,31,179,31,95,31,210,31,223,31,133,31,53,31,65,31,200,31,200,30,156,31,207,31,145,31,145,30,171,31,40,31,151,31,151,30,31,31,38,31,219,31,219,30,26,31,206,31,38,31,38,30,38,29,246,31,126,31,225,31,222,31,130,31,197,31,127,31,12,31,134,31,4,31,106,31,69,31,72,31,146,31,20,31,163,31,209,31,55,31,113,31,173,31,173,30,212,31,155,31,228,31,86,31,226,31,111,31,111,30,20,31,157,31,43,31,43,30,249,31,249,30,229,31,229,30,229,29,198,31,15,31,235,31,141,31,87,31,6,31,198,31,107,31,107,30,81,31,148,31,246,31,246,30,208,31,199,31,16,31,159,31,97,31,9,31,149,31,89,31,176,31,208,31,59,31,183,31,183,30,19,31,67,31,137,31,53,31,53,30,201,31,25,31,93,31,250,31,71,31,50,31,45,31,115,31,115,30,179,31,67,31,113,31,98,31,98,30,132,31,131,31,251,31,168,31,127,31,51,31,254,31,177,31,154,31,162,31,167,31,235,31,235,30,235,29,150,31,41,31,82,31,236,31,236,30,236,29,216,31,216,30,6,31,13,31,2,31,220,31,72,31,72,30,72,29,72,28,214,31,167,31,11,31,106,31,33,31,33,30,33,29,129,31,76,31,69,31,133,31,187,31,241,31,241,30,143,31,143,30,210,31,148,31,19,31,19,30,24,31,196,31,21,31,21,30,136,31,136,30,141,31,200,31,182,31,186,31,6,31,26,31,93,31,93,30,217,31,13,31,149,31,55,31,55,30,138,31,52,31,36,31,127,31,164,31,89,31,216,31,140,31,140,30,148,31,95,31,167,31,77,31,81,31,20,31,163,31,163,30,91,31,57,31,96,31,96,30,48,31,93,31,239,31,239,30,189,31,234,31,234,30,22,31,193,31,34,31,34,30,34,29,159,31,160,31,160,30,1,31,1,30,1,29,234,31,43,31,116,31,75,31,14,31,66,31,66,30,53,31,165,31,47,31,210,31,178,31,149,31,39,31,18,31,61,31,39,31,26,31,106,31,106,30,124,31,215,31,231,31,135,31,37,31,37,30,146,31,64,31,168,31,29,31,207,31,207,30,57,31,42,31,210,31,150,31,150,30,129,31,173,31,173,30,173,29,64,31,64,30,64,29,122,31,105,31,42,31,159,31,8,31,8,30,18,31,15,31,15,30,205,31,13,31,165,31,165,30,147,31,207,31,207,30,232,31,147,31,139,31,112,31,112,30,59,31,31,31,203,31,203,30,165,31);

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
