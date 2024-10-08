-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_676 is
end project_tb_676;

architecture project_tb_arch_676 of project_tb_676 is
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

constant SCENARIO_LENGTH : integer := 307;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (78,0,160,0,91,0,0,0,158,0,223,0,251,0,77,0,155,0,7,0,195,0,118,0,165,0,0,0,47,0,20,0,0,0,161,0,36,0,147,0,111,0,0,0,223,0,0,0,97,0,0,0,174,0,78,0,63,0,217,0,58,0,254,0,127,0,217,0,144,0,180,0,230,0,138,0,95,0,0,0,210,0,162,0,33,0,0,0,36,0,89,0,0,0,140,0,170,0,43,0,175,0,55,0,108,0,112,0,15,0,158,0,40,0,24,0,75,0,171,0,168,0,3,0,242,0,0,0,11,0,147,0,67,0,66,0,0,0,87,0,13,0,249,0,139,0,0,0,124,0,75,0,0,0,0,0,126,0,142,0,120,0,196,0,111,0,200,0,156,0,234,0,3,0,10,0,0,0,189,0,89,0,221,0,177,0,134,0,157,0,100,0,0,0,0,0,0,0,20,0,238,0,60,0,168,0,101,0,11,0,33,0,177,0,44,0,202,0,205,0,47,0,34,0,0,0,126,0,170,0,216,0,0,0,2,0,22,0,74,0,110,0,221,0,5,0,64,0,107,0,161,0,0,0,57,0,80,0,0,0,211,0,54,0,0,0,0,0,154,0,55,0,173,0,171,0,0,0,91,0,244,0,226,0,220,0,0,0,192,0,87,0,114,0,0,0,240,0,0,0,193,0,227,0,63,0,13,0,64,0,117,0,27,0,141,0,160,0,252,0,0,0,83,0,232,0,111,0,0,0,0,0,3,0,58,0,85,0,249,0,181,0,233,0,0,0,0,0,10,0,90,0,251,0,203,0,217,0,205,0,202,0,191,0,226,0,54,0,94,0,253,0,246,0,227,0,104,0,52,0,156,0,51,0,120,0,52,0,112,0,206,0,81,0,0,0,247,0,181,0,30,0,245,0,0,0,115,0,245,0,110,0,112,0,37,0,221,0,184,0,237,0,0,0,0,0,50,0,0,0,0,0,218,0,220,0,224,0,4,0,156,0,251,0,255,0,35,0,120,0,211,0,136,0,215,0,87,0,0,0,27,0,86,0,0,0,42,0,5,0,36,0,0,0,86,0,236,0,236,0,183,0,46,0,181,0,172,0,0,0,58,0,111,0,248,0,64,0,136,0,0,0,121,0,60,0,178,0,201,0,181,0,174,0,0,0,169,0,20,0,0,0,55,0,0,0,236,0,0,0,145,0,251,0,121,0,56,0,202,0,35,0,0,0,0,0,106,0,0,0,102,0,113,0,4,0,95,0,28,0,85,0,99,0,0,0,208,0,87,0,0,0,236,0,0,0,213,0,31,0,0,0,0,0,94,0,0,0,97,0,109,0,75,0,202,0,233,0,122,0,0,0,37,0,140,0,133,0,0,0,192,0,255,0);
signal scenario_full  : scenario_type := (78,31,160,31,91,31,91,30,158,31,223,31,251,31,77,31,155,31,7,31,195,31,118,31,165,31,165,30,47,31,20,31,20,30,161,31,36,31,147,31,111,31,111,30,223,31,223,30,97,31,97,30,174,31,78,31,63,31,217,31,58,31,254,31,127,31,217,31,144,31,180,31,230,31,138,31,95,31,95,30,210,31,162,31,33,31,33,30,36,31,89,31,89,30,140,31,170,31,43,31,175,31,55,31,108,31,112,31,15,31,158,31,40,31,24,31,75,31,171,31,168,31,3,31,242,31,242,30,11,31,147,31,67,31,66,31,66,30,87,31,13,31,249,31,139,31,139,30,124,31,75,31,75,30,75,29,126,31,142,31,120,31,196,31,111,31,200,31,156,31,234,31,3,31,10,31,10,30,189,31,89,31,221,31,177,31,134,31,157,31,100,31,100,30,100,29,100,28,20,31,238,31,60,31,168,31,101,31,11,31,33,31,177,31,44,31,202,31,205,31,47,31,34,31,34,30,126,31,170,31,216,31,216,30,2,31,22,31,74,31,110,31,221,31,5,31,64,31,107,31,161,31,161,30,57,31,80,31,80,30,211,31,54,31,54,30,54,29,154,31,55,31,173,31,171,31,171,30,91,31,244,31,226,31,220,31,220,30,192,31,87,31,114,31,114,30,240,31,240,30,193,31,227,31,63,31,13,31,64,31,117,31,27,31,141,31,160,31,252,31,252,30,83,31,232,31,111,31,111,30,111,29,3,31,58,31,85,31,249,31,181,31,233,31,233,30,233,29,10,31,90,31,251,31,203,31,217,31,205,31,202,31,191,31,226,31,54,31,94,31,253,31,246,31,227,31,104,31,52,31,156,31,51,31,120,31,52,31,112,31,206,31,81,31,81,30,247,31,181,31,30,31,245,31,245,30,115,31,245,31,110,31,112,31,37,31,221,31,184,31,237,31,237,30,237,29,50,31,50,30,50,29,218,31,220,31,224,31,4,31,156,31,251,31,255,31,35,31,120,31,211,31,136,31,215,31,87,31,87,30,27,31,86,31,86,30,42,31,5,31,36,31,36,30,86,31,236,31,236,31,183,31,46,31,181,31,172,31,172,30,58,31,111,31,248,31,64,31,136,31,136,30,121,31,60,31,178,31,201,31,181,31,174,31,174,30,169,31,20,31,20,30,55,31,55,30,236,31,236,30,145,31,251,31,121,31,56,31,202,31,35,31,35,30,35,29,106,31,106,30,102,31,113,31,4,31,95,31,28,31,85,31,99,31,99,30,208,31,87,31,87,30,236,31,236,30,213,31,31,31,31,30,31,29,94,31,94,30,97,31,109,31,75,31,202,31,233,31,122,31,122,30,37,31,140,31,133,31,133,30,192,31,255,31);

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
